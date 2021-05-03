//
//  ViewController.swift
//  FirebaseProj
//
//  Created by 김도연 on 2021/04/09.
//

import UIKit
import Firebase


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func SignIn(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
            
            if error != nil {
                Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                    
                }
            } else {
                let alert = UIAlertController(title: "알림", message: "회원가입완료", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            
            
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
             
                self.performSegue(withIdentifier: "Home", sender: nil)
            }
        }
        
    }
    
    
 
    

}

