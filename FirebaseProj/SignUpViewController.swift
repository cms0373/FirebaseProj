//
//  SignUpViewController.swift
//  FirebaseProj
//
//  Created by 김도연 on 2021/05/03.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var pwAgainField: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func ClearTextField() {
        self.emailField.text = ""
        self.pwField.text = ""
        self.pwAgainField.text = ""
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true) {
            self.ClearTextField()
        }
    }

    @IBAction func signUpButton(_ sender: Any) {
        
        if pwField.text!.count < 6 {
           print("비번 6자리 이하임. 오류")
           let alert = UIAlertController(title: "오류", message: "비밀번호는 6자리 이상이어야 합니다", preferredStyle: .alert)
           
           alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
           self.present(alert, animated: true, completion: {
            self.ClearTextField()
           })
            return
       } else if pwField.text! != pwAgainField.text! {
            //비번 != 비밀번호확인
            print("비번 1, 2 가 다름. 오류")
            let alert = UIAlertController(title: "오류", message: "비밀번호를 잘못 입력하셨습니다", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: {
                self.ClearTextField()
            })
            return
        }
        
        Auth.auth().createUser(withEmail: emailField.text!, password: pwField.text!) { (authResult, error) in
            print(error?.localizedDescription)
            
            guard let user = authResult?.user else {
                print("이미 가입된 이메일임")
                
                let alert = UIAlertController(title: "오류", message: "이미 등록된 회원입니다", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true) {
                    self.ClearTextField()
                }
                return
            }
            
            
            print(user)
            
            let alert = UIAlertController(title: "알림", message: "회원가입을 축하합니다!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true) {
                self.ClearTextField()
            }
            
            
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
