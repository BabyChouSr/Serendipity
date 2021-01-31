//
//  LoginViewController.swift
//  Serendipity
//
//  Created by Akshay Kumar on 1/31/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
    }
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBAction func loginUser(_ sender: UIButton) {
        if let email = emailTF.text, let pass = passwordTF.text{
            Auth.auth().signIn(withEmail: email, password: pass) { (authResult, error) in
                if let e = error{
                    print(e)
                } else{
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
