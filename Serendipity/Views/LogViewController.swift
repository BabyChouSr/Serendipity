//
//  ViewController.swift
//  Serendipity
//
//  Created by Kevin Pradjinata on 1/30/21.
//

import UIKit
import Firebase

class LogViewController: UIViewController {


    
    
    @IBOutlet var tableView: UITableView!
    let db = Firestore.firestore()
    var moodLogs : [MoodLog] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MoodLogCell", bundle: nil), forCellReuseIdentifier:  "moodCellID")
        
        loadMoods()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = false
    }
    

    
    
    func loadMoods() {
        
        db.collection("logs").document("a@k.com").collection("entries")
            .order(by: "order", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
            
            self.moodLogs = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                print("babu")
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        print(data)
                        if let activity = data["activity"] as? [String], let question = data["question"] as? String, let transcript = data["transcript"] as? String, let date = data["date"] as? String, let detEmo = data["emotionDetected"] as? String, let userEmo = data["userDetected"] as? String{
                            let newMood = MoodLog(userEmo: userEmo, detEmo: detEmo, date: date, activity: activity, audioPath: "", transcript: transcript, question: question) //create new messages
                            self.moodLogs.append(newMood)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.moodLogs.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
}


    

func commaSepWords(words: [String]) -> String{
    var x = ""
    for i in 0...words.count-1{
        if i < words.count - 1{
            x += "\(words[i].uppercased()), "
        } else{
            x += words[i].uppercased()
        }
    }
    return x
}


extension LogViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moodLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moodCellID", for: indexPath) as! MoodLogCell
        cell.activityLabel.text = commaSepWords(words: moodLogs[indexPath.row].activity)
        cell.questionLabel.text = moodLogs[indexPath.row].question
        cell.transcriptView.text = moodLogs[indexPath.row].transcript
        cell.dateLabel.text = moodLogs[indexPath.row].date
        
        cell.algoEmoji.text = moodLogs[indexPath.row].detEmo
        cell.userEmoji.text = moodLogs[indexPath.row].userEmo
        
//        cell.textLabel?.text = moodLogs[indexPath.row].transcript
        return cell
    }
    
    
}

extension LogViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Int(moodLogs[indexPath.row].date.prefix(2)) == 31{
            performSegue(withIdentifier: "lowOnTime", sender: tableView)
        }
    }
}
