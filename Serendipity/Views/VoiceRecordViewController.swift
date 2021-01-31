//
//  VoiceRecordViewController.swift
//  Serendipity
//
//  Created by Kevin Pradjinata on 1/30/21.
//



import UIKit
import Speech
import Firebase
import Alamofire


class VoiceRecordViewController: UIViewController, SFSpeechRecognizerDelegate, UITextViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var recordingBabu: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var buttonBackView: UIView!
    
    let db = Firestore.firestore()
    var emotionValue: String?
    
    var dateSelect: String?
    var moodThings: [String] = []
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    static var sTime = CFAbsoluteTimeGetCurrent()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
        buttonBackView.layer.cornerRadius = 50
        
        microphoneButton?.isEnabled = false
            
        speechRecognizer?.delegate = self  //created a question mark here
            
            SFSpeechRecognizer.requestAuthorization { (authStatus) in
                
                var isButtonEnabled = false
                
                switch authStatus {
                case .authorized:
                    isButtonEnabled = true
                    
                case .denied:
                    isButtonEnabled = false
                    print("User denied access to speech recognition")
                    
                case .restricted:
                    isButtonEnabled = false
                    print("Speech recognition restricted on this device")
                    
                case .notDetermined:
                    isButtonEnabled = false
                    print("Speech recognition not yet authorized")
                }
                
                OperationQueue.main.addOperation() {
                    self.microphoneButton?.isEnabled = isButtonEnabled
                }
            }
    }
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func setupView() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record
        }
    }
    
    func loadRecordingUI() {
        recordingBabu.isEnabled = true
        playButton.isEnabled = false
        recordingBabu.setTitle("Tap to Record", for: .normal)
        recordingBabu.addTarget(self, action: #selector(recordAudioButtonTapped), for: .touchUpInside)
        view.addSubview(recordingBabu)
    }
    
    @objc func recordAudioButtonTapped(_ sender: UIButton) {
        if audioRecorder == nil {
            startPlayingRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func startPlayingRecording() {
        let audioFilename = getFileURL()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            //audioRecorder.record()
            
            recordingBabu.setTitle("Tap to Stop", for: .normal)
            playButton.isEnabled = false
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordingBabu.setTitle("Tap to Re-record", for: .normal)
        } else {
            recordingBabu.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
        
        playButton.isEnabled = true
        recordingBabu.isEnabled = true
    }
    
    @IBAction func playAudioButtonTapped(_ sender: UIButton) {
        if (sender.titleLabel?.text == "Play"){
            recordingBabu.isEnabled = false
            sender.setTitle("Stop", for: .normal)
            preparePlayer()
            audioPlayer.play()
        } else {
            audioPlayer?.stop()
            sender.setTitle("Play", for: .normal)
        }
    }
    
    func preparePlayer() {
        var error: NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileURL() as URL)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 10.0
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return paths[0]
        
    }
    // "/User/babu/sadf/" + "recording.m4a"
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        return path as URL
    }
    
    //MARK: Delegates
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordingBabu.isEnabled = true
        playButton.setTitle("Play", for: .normal)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
    
    //MARK: To upload video on server
    
    func uploadAudioToServer() {
        /*Alamofire.upload(
         multipartFormData: { multipartFormData in
         multipartFormData.append(getFileURL(), withName: "audio.m4a")
         },
         to: "https://yourServerLink",
         encodingCompletion: { encodingResult in
         switch encodingResult {
         case .success(let upload, _, _):
         upload.responseJSON { response in
         Print(response)
         }
         case .failure(let encodingError):
         print(encodingError)
         }
         })*/
    }
    
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//            self.view.endEditing(true)
//            return false
//        }
 

    @IBAction func microphoneTapped(_ sender: AnyObject) {
        if audioEngine.isRunning {
                audioEngine.stop()
                recognitionRequest?.endAudio()
                microphoneButton.isEnabled = false
                microphoneButton.setTitle("🎤", for: .normal)
            
            } else {
                startRecording()
                microphoneButton.setTitle("🔴", for: .normal)
            }
    }
        
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
       let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in //added question mark here
            
            var isFinal = false
            
            if result != nil {
                self.textView.text = result?.bestTranscription.formattedString //bestTranscriptiuon is black
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {(buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        textView.text = "Say something, I'm listening!"
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
   
    
    static var activityList: [String] = []
    @IBAction func pressedButt(_ sender: UIButton) {
        
        sender.isSelected.toggle()
        sender.backgroundColor = UIColor.white
        VoiceRecordViewController.activityList.append((sender.titleLabel?.text)!)
    }
    
    func parseMood(score: Double) -> String{
        if score < -0.6{
            return "😫"
        }
        else if score < -0.2{
            return "☹️"
        }
        else if score < 0.2{
            return "😐"
        }
        else if score < 0.6{
            return "🙂"
        } else{
            return "🥳"
        }
    }
    

    
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        let ref = db.collection("logs")
        
        
        if let ds = dateSelect, let transcript = textView.text{
            let urlTranscript = transcript.replacingOccurrences(of: " ", with: "%20")
            print(urlTranscript)
            let order = Int(ds.prefix(2))
            let request = AF.request("https://depressoapi.herokuapp.com/moodDetect/" + urlTranscript)
            
                request.responseDecodable(of: Mood.self) { (response) in
                    guard let moods = response.value else { return }
                    
                        let emo = self.parseMood(score: moods.mood)
                        ref.document("a@k.com").collection("entries").addDocument(data: [ // change document based on user's emailz
                            
                            "date" : ds,
                            "activity" : VoiceRecordViewController.activityList,
                            "transcript": transcript,
                            "question": "How are you relationships with your friends and family?", //question
                            "emotionDetected": emo,
                            "userDetected": self.moodThings[0],
                            "order": order,
                            "dateCreated": Double(CFAbsoluteTimeGetCurrent())
                        ])
                    self.moodThings = []
                }
            


            
        }
        
        
    }
    
}



