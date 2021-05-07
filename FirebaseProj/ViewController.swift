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
    
    func ClearTextField() {
        email.text = ""
        password.text = ""
    }
    //로그인 기능 구현
    @IBAction func SignIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if user != nil {
                print("login success")
                self.ClearTextField()
                
                let alert = UIAlertController(title: "로그인 성공", message: "환영합니다!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (UIAlertAction) in
                    self.performSegue(withIdentifier: "Home", sender: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                print("login fail")
                
                let alert = UIAlertController(title: "로그인 실패", message: "ID 혹은 Password가 올바르지 않습니다", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: {
                    self.ClearTextField()
                })
            }
        }
        /*
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
        */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("첫화면을 로딩합니다")
        
        /*
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                print("뷰 전환을 하게따아아아아아")
                self.performSegue(withIdentifier: "Home", sender: nil)
            }
        }
         */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //로그인 상태라면, home으로 뷰를 전환한다
        if Auth.auth().currentUser != nil {
            print("로그인 상태입니다")
            self.performSegue(withIdentifier: "Home", sender: nil)

        }
    }
    
    
 
    

}

