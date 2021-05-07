//
//  DetailViewController.swift
//  FirebaseProj
//
//  Created by 김도연 on 2021/05/03.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DetailViewController: UIViewController {

    var info = UserDTO()
    var uidArray: [String] = []
    var targetPath: Int = 0
 
 
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productContent: UILabel!
    @IBOutlet weak var period: UILabel!
    @IBOutlet weak var userPostion: UILabel!
    @IBOutlet weak var like: UILabel!
    
    @IBOutlet weak var starBtn: UIButton!
    
    
    
    @IBAction func clickStarBtn(_ sender: Any) {
        
        print("버튼을 눌렀습니다")
        
        starBtn.tag = targetPath
        
        starBtn.addTarget(self, action: #selector(likeBtn(_:)), for: .touchUpInside)
        
        //지금 스타 찍혀있으면
        if starBtn.currentImage == UIImage(systemName: "star") {
            starBtn.setImage(UIImage(systemName: "star.fill"), for: .normal)
            
            print(like.text)
            
        } else {    //안찍혀있으면
            starBtn.setImage(UIImage(systemName: "star"), for: .normal)
            print(like.text)
        }
        
    }
    
    @objc func likeBtn(_ sender: UIButton) {
        print("왜 이건 작동안하지?")
        Database.database().reference().child("users").child(self.uidArray[sender.tag]).runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
          if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
            var stars: Dictionary<String, Bool>
            stars = post["stars"] as? [String : Bool] ?? [:]
            var starCount = post["starCount"] as? Int ?? 0
            if let _ = stars[uid] {
                // Unstar the post and remove self from stars
                starCount -= 1
                stars.removeValue(forKey: uid)
                print("unstar!!!")
            } else {
                // Star the post and add self to stars
                starCount += 1
                stars[uid] = true
                print("star")
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //starbtn 부분
        if let currentLike = info.starCount?.intValue {
            like.text = "☆\(currentLike)"
        }
        
        //만약 현재 like 가 찍혀있다면
        if info.stars?[info.uid!] ==  true {
            print("즐겨찾기 이미 찍혀있음")
            starBtn.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            print("즐겨찾기 안찍혀있음")
            starBtn.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        //title 부분
        productTitle.text = info.subject
        productTitle.font = UIFont.boldSystemFont(ofSize: 30)
        
        //period 부분
        if let day = Int(info.period!) {
            period.text = "\(day)일"
        } else {
            period.text = info.period
        }
        period.font = UIFont.boldSystemFont(ofSize: 20)
        

        
        
        productImg.image = info.productImage
        productContent.text = info.context
      
 
        if info.uid == Auth.auth().currentUser?.uid {
            print("It's my post!")
        }

    }
    


}
