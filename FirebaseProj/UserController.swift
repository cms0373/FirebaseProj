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
    
}
