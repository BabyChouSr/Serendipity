//
//  HomeViewController.swift
//  Serendipity
//
//  Created by Kevin Pradjinata on 1/30/21.
//

import UIKit
import LocalAuthentication

class HomeViewController: UIViewController {
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var dailyQuoteBackground: UIView!
    @IBOutlet weak var goalsBackground: UIView!
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth()
        dailyQuoteBackground.layer.cornerRadius = 28
        goalsBackground.layer.cornerRadius = 28
        mainView.layer.cornerRadius = 50
        

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = false
        // Do any additional setup after loading the view.
    }
    
    func auth() {
        let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [weak self] success, authenticationError in

                    DispatchQueue.main.async {
                        if success {
                            self?.hideView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                        } else {
                            let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self!.present(ac, animated: true)
                        }
                    }
                }
            } else {
                let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

