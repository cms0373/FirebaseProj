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
                print("데이터다운받는다",fchild)
                if let dictionary = fchild.value as? [String: Any] {
                    //print("dic:" , dictionary)
                    print("download data from server")
                    let user = UserDTO()
                    let uidKey = fchild.key
                    
                    user.uid = dictionary["uid"] as? String
                    user.userID = dictionary["userID"] as? String
                    user.context = dictionary["context"] as? String
                    user.subject = dictionary["subject"] as? String
                    user.imageUrl = dictionary["imageUrl"] as? String
                    user.stars = dictionary["stars"] as? [String : Bool]
                    user.starCount = dictionary["starCount"] as? NSNumber
                    user.imageName = dictionary["imageName"] as? String
                    
                    user.category = dictionary["category"] as? String
                    user.period = dictionary["period"] as? String
                    
                    self.array.insert(user, at: 0)
                    self.uidKey.insert(uidKey, at: 0)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /*
    @objc func like(_ sender : UIButton) {
        
        Database.database().reference().child("users").child(self.uidKey[sender.tag]).runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
          if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
            var stars: Dictionary<String, Bool>
            stars = post["stars"] as? [String : Bool] ?? [:]
            var starCount = post["starCount"] as? Int ?? 0
            if let _ = stars[uid] {
              // Unstar the post and remove self from stars
              starCount -= 1
              stars.removeValue(forKey: uid)
            } else {
              // Star the post and add self to stars
              starCount += 1
              stars[uid] = true
            }
            post["starCount"] = starCount as AnyObject?
            post["stars"] = stars as AnyObject?

            // Set value and report transaction success
            currentData.value = post

            return TransactionResult.success(withValue: currentData)
          }
          return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
          if let error = error {
            print(error.localizedDescription)
          }
        }
    }
     */
    


}

extension TableListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        cell.selectionStyle = .none
        let target = array[indexPath.row]
        
        if let productTitle = cell.viewWithTag(200) as? UILabel {
            productTitle.text = target.subject
            productTitle.font = UIFont.boldSystemFont(ofSize: 20)
        }
        
        if let periodText = cell.viewWithTag(400) as? UILabel {
            if let day = Int(target.period!) {
                periodText.text =  "\(day)일"
            } else {
                periodText.text = target.period
            }
            
            periodText.font = UIFont.systemFont(ofSize: 10)
            
            
        }
        
        if let img = cell.viewWithTag(100) as? UIImageView {
            URLSession.shared.dataTask(with: URL(string: array[indexPath.row].imageUrl!)!) { data, response, err in
                if err != nil {
                    return
                }
                
                DispatchQueue.main.async {
                    img.image = UIImage(data: data!)
                    self.array[indexPath.row].productImage = img.image
                }
            }.resume()
            
        }
        
        

 
        print("cell을 표시합니다..")
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let detailViewController = segue.destination as! DetailViewController
            
            let senderCell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: senderCell)
            let senderCellData = array[indexPath!.row]
            detailViewController.info = senderCellData
            detailViewController.uidArray = uidKey
            detailViewController.targetPath = indexPath!.row
            
            //print("segue: ", array[indexPath!.row])
        }
    }
}

class TableCell: UITableViewCell {
    
}
