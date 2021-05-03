//
//  EmailSignUpViewController.swift
//  FirebaseProj
//
//  Created by 김도연 on 2021/04/09.
//

import UIKit
import FirebaseAuth

class EmailSignUpViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func SignUp(_ sender: UIButton) {
        guard let email = emailText.text, let password = passwordText.text else {return}
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            print(authResult)
            print(email,password)
            guard let user = authResult?.user else {return}
            
            print("user1")
            
            print("\(user.email!) created")
            
            if error == nil {
                
            } else {
                
            }
        }
    }
    

}
