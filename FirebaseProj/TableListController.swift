//
//  TableListController.swift
//  FirebaseProj
//
//  Created by 김도연 on 2021/04/09.
//

import UIKit
import Firebase
import FirebaseDatabase

class TableListController: UIViewController {
    
    var array: [UserDTO] = []
    var uidKey : [String] = []
    @IBOutlet weak var tableView: UITableView!
    
    func getDataFromServer() {
        Database.database().reference().child("users").observe(DataEventType.value) { (DataSnapshot) in
            
            self.array.removeAll()
            self.uidKey.removeAll()

            for child in DataSnapshot.children {
                let fchild = child as! DataSnapshot
                if let dictionary = fchild.value as? [String: Any] {
                    print(dictionary)
                    let user = UserDTO()
                    let uidKey = fchild.key
                    
                    user.uid = dictionary["uid"] as? String
                    user.userID = dictionary["userID"] as? String
                    user.explanation = dictionary["explanation"] as? String
                    user.subject = dictionary["subject"] as? String
                    user.imageUrl = dictionary["imageUrl"] as? String
                    self.array.append(user)
                    self.uidKey.append(uidKey)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getDataFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataFromServer()
    }
    


}

extension TableListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        
        let target = array[indexPath.row]
        
        if let dataLabel = cell.viewWithTag(200) as? UILabel {
            dataLabel.text = target.subject
        }
        
        if let img = cell.viewWithTag(100) as? UIImageView {
        
            let data = try? Data(contentsOf: URL(string: array[indexPath.row].imageUrl!)!)
            print(data)
            //img.image = UIImage(data: data!)
        }
        print("cell을 표시합니다..")
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let detailViewController = segue.destination as! DetailViewController
            
            let senderCell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: senderCell)
            //let senderCellName = array[indexPath!.row].subject
            //detailViewController.name = senderCellName!
            
        }
    }
}

class TableCell: UITableViewCell {
    
}
