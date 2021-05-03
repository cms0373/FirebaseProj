//
//  LoginViewController.swift
//  FirebaseProj
//
//  Created by 김도연 on 2021/04/09.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pw: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Auth.auth().currentUser {
            print("? log in?")
            print(Auth.auth().currentUser)
            email.placeholder = "already login"
            pw.placeholder = "already login"
            
        }

    }
    

    @IBAction func LoginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: pw.text!) { (user, error) in
            
            if user != nil {
                print("login success")
            } else {
                print("login fail")
            }
        }
    }
    

}
