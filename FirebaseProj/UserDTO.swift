//
//  UserDTO.swift
//  FirebaseProj
//
//  Created by 김도연 on 2021/04/09.
//

import UIKit

//@objcMembers
class UserDTO: NSObject {
    var uid: String?
    var userID: String?
    var subject: String?
    var context: String?
    var imageUrl: String?
    var productImage: UIImage?
    var imageName: String?
    
    var uploadTime: String?
    var uploadPos: String?
    
    var category: String?
    var period: String?
    var starCount: NSNumber?
    var stars: [String:Bool]?
}
