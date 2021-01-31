//
//  HelpViewController.swift
//  Serendipity
//
//  Created by Akshay Kumar on 1/31/21.
//

import UIKit

class HelpViewController: UIViewController {
    
    
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var callView: UIView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = false
        
        
        backgroundView.layer.cornerRadius = 30
        emailView.layer.cornerRadius = 18
        callView.layer.cornerRadius = 18

    }
}
