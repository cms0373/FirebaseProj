//
//  UploadController.swift
//  FirebaseProj
//
//  Created by 김도연 on 2021/04/09.
//

import UIKit
import Firebase
import FirebaseDatabase

class UploadController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var explaination: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(OpenGallery))
        
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    @IBAction func UploadButton(_ sender: Any) {
        upload()
    }
    
     @objc func OpenGallery() {
        let imagePick = UIImagePickerController()
        imagePick.delegate = self
        imagePick.allowsEditing = true
        imagePick.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(imagePick, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imageView.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        dismiss(animated: true, completion: nil)
    }
    
    func upload() {
        let image = self.imageView.image?.pngData()
        
        let imageName = Auth.auth().currentUser!.uid + "\(Int(NSDate.timeIntervalSinceReferenceDate * 1000)).jpg"
        
        let riversRef = Storage.storage().reference().child("ios_images").child(imageName)
        
        riversRef.putData(image!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("error??")
                return
            }
            print("upload1")
            
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url?.absoluteString else {
                    print("uploaderror2")
                    return
                }
                print("upload2")
                
                Database.database().reference().child("users").childByAutoId().setValue([
                    "userID": Auth.auth().currentUser?.email,
                    "uid": Auth.auth().currentUser?.uid,
                    "subject": self.subject.text!,
                    "explaination": self.explaination.text!,
                    "imageUrl": downloadURL,
                    
                ])
                self.dismiss(animated: true, completion: nil)
            }
        }
        print("upload!!")
    }
}
