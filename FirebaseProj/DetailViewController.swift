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
    
    var isStar: Bool = false
    var isServer: Bool = false
    
    
    @IBAction func clickStarBtn(_ sender: Any) {
        
        starBtn.tag = targetPath
        
        
        starBtn.addTarget(self, action: #selector(likeBtn(_:)), for: .touchUpInside)
        
        print("버튼 클릭")
        if isServer == true {
            if isStar == false {
                print("스타로 바꾼다")
                starBtn.setImage(UIImage(systemName: "star.fill"), for: .normal)
                
            } else {
                print("빈스타로 바꾼다")
                starBtn.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }

        
    }
    
    @objc func likeBtn(_ sender: UIButton) {
        self.isServer = true
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
                self.isStar = false
            } else {
                // Star the post and add self to stars
                starCount += 1
                stars[uid] = true
                print("star")
                self.isStar = true
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
    @objc func MoreInfo(_ sender: UIButton) {
        print("more BTn")
        let alert = UIAlertController(title: "Edit", message: "옵션을 선택하세요", preferredStyle: .actionSheet)
 
        alert.addAction(UIAlertAction(title: "수정", style: .default, handler: { UIAlertAction in
            return
        }))
        
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { UIAlertAction in
            return
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if info.uid == Auth.auth().currentUser?.uid {
            print("It's my post!")
            let moreBtn = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(MoreInfo(_ :)))
            self.navigationItem.rightBarButtonItem = moreBtn
        }
        //수정, 삭제 버튼
        
        
        
        
        
        
        
        //starbtn 부분
        if let currentLike = info.starCount?.intValue {
            like.text = "☆ \(currentLike)"
        }
        
        //만약 현재 like 가 찍혀있다면
        let userID = Auth.auth().currentUser?.uid
        print(userID,"유저 아이디입니다")

        if info.stars?[userID!] ==  true {
            print("즐겨찾기 이미 찍혀있음")
            starBtn.setImage(UIImage(systemName: "star.fill"), for: .normal)
            isStar = true
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
      
 
        

    }
    


}
