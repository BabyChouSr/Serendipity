//
//  DataSelectViewController.swift
//  Serendipity
//
//  Created by Kevin Pradjinata on 1/30/21.
//



import UIKit

class DateSelectViewController: UIViewController {
    @IBOutlet weak var dateTime: UIDatePicker!
    @IBOutlet weak var mainView: UIView!

    
    static var date:String?
    
    static var moodLis: [String] = []
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = false
        mainView.layer.cornerRadius = 50
        
        // Do any additional setup after loading the view
    }
    func storeDate() {
        dateTime.datePickerMode = UIDatePicker.Mode.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let selectedDate = dateFormatter.string(from: dateTime.date)
        DateSelectViewController.date = selectedDate
    }

    @IBAction func moodIsPressed(_ sender: UIButton) {
        DateSelectViewController.moodLis = []
        sender.isSelected.toggle()
        DateSelectViewController.moodLis.append((sender.titleLabel?.text)!)
        sender.layer.cornerRadius = 35
        sender.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
    }
    
    @IBAction func continueButt(_ sender: UIButton) {
        storeDate()
        
        
        self.performSegue(withIdentifier: "continueToLogs", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "continueToLogs" {
            let destinationVC = segue.destination as! VoiceRecordViewController
            destinationVC.dateSelect = DateSelectViewController.date!
            destinationVC.moodThings = DateSelectViewController.moodLis
        }
    }
    
}
