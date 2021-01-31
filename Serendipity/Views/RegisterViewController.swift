//
//  RegisterViewController.swift
//  Serendipity
//
//  Created by Akshay Kumar on 1/31/21.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.delegate = self
        passwordTF.delegate = self
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpUser(_ sender: UIButton) {
        if let email = emailTF.text, let pass = passwordTF.text{
            print("click")
            Auth.auth().createUser(withEmail: email, password: pass) { (authResult, error) in
                print("acooutn")
                if let e = error{
                    print(e.localizedDescription)
                } else{
                    self.performSegue(withIdentifier: "signupSegue", sender: sender)
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
