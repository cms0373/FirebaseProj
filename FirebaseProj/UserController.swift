//
//  UserController.swift
//  FirebaseProj
//
//  Created by 김도연 on 2021/04/09.
//

import UIKit
import Firebase

class UserController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func LogoutBtn(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
        dismiss(animated: true, completion: nil)
    }
  
    @IBAction func UserDeleteBtn(_ sender: Any) {
        
    
        let alert = UIAlertController(title: "경고", message: "정말 탈퇴하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "탈퇴하기", style: .destructive, handler: { UIAlertAction in
            
            let user = Auth.auth().currentUser
            user?.delete(completion: { Error in
                if let err = Error {
                    print("ERROR!!!")
                    print(err)
                } else {
                    
                    let alert2 = UIAlertController(title: "성공", message: "탈퇴완료", preferredStyle: .alert)
                    alert2.addAction(UIKit.UIAlertAction(title: "확인", style: .default, handler: { UIAlertAction in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alert2, animated: true, completion: nil)
                  
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { UIAlertAction in
            return
        }))
        
        self.present(alert, animated: true, completion: nil)
        
 
        
        
    }
    
    
    
}
