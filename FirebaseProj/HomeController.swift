//
//  HomeController.swift
//  FirebaseProj
//
//  Created by 김도연 on 2021/04/09.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeController: UIViewController{

    var array: [UserDTO] = []
    var uidKey : [String] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //getDataFromServer()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //getDataFromServer()
        
    }


}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowCell", for: indexPath) as! CustomCell
        
        print("여기를 안들어온다고?")
        
        cell.subject.text = array[indexPath.row].subject
        cell.explanation.text = array[indexPath.row].explanation
        
        let data = try? Data(contentsOf: URL(string: array[indexPath.row].imageUrl!)!)
        cell.imgView.image = UIImage(data: data!)
        
        print("why??")
        print(array)
        print("noArray?!!")
        
        return cell
    }
}

class CustomCell : UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var explanation: UILabel!
    

}
