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
    @IBOutlet weak var context: UITextView!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var borrowPeriod: UITextField!
    
    
    var picker: UIPickerView!
    var pickerList: [String] = ["당일"]
    
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //productImg 부분
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        
        
        
        //context 부분
        context.layer.borderWidth = 1.0
        context.layer.borderColor = UIColor.gray.cgColor
        
        
        categoryText.isUserInteractionEnabled = false
        //borrowPeriod.isUserInteractionEnabled = false
        
        //대여기간 설정 picker view
        picker = UIPickerView()
        picker.delegate = self
        borrowPeriod.inputView = picker
        for i in 1...30 {
            pickerList.append("\(i)")
        }
        pickerList.append("제한없음")
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(OpenGallery))
        
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        placeholderSetting()
        
        print("뷰디드로드")
    }
    
    @IBAction func CategoryListBtn(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "productList") as? ProductListTableViewController else { return }
        
        vc.completionHandler = {
            text in
            self.categoryText.text = text
            return text
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func CompleteButton(_ sender: Any) {
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
        self.imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    func upload() {
        
        
        if self.imageView.image == UIImage(systemName: "plus.viewfinder") || self.subject.text == "" || self.categoryText.text == "" || self.borrowPeriod.text == "" {
            
            var emptyInfo: String = ""
    
            
            if self.imageView.image == nil {
                emptyInfo += "물품 이미지\n"
            }
            
            if self.subject.text == "" {
                emptyInfo += "물품 제목\n"
            }

            if self.categoryText.text == "" {
                emptyInfo += "물품 카테고리\n"
            }
            if self.borrowPeriod.text == "" {
                emptyInfo += "물품 대여가능기간\n"
            }
            emptyInfo += "을(를) 채워주세요"
            
            let alert = UIAlertController(title: "빠진 정보가 있습니다", message: emptyInfo, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
            return
        }
        
        
        let image = self.imageView.image?.jpegData(compressionQuality: 0.1)
        
        let imageName = Auth.auth().currentUser!.uid + "\(Int(NSDate.timeIntervalSinceReferenceDate * 1000)).jpg"
                
        let riversRef = Storage.storage().reference().child("ios_images").child(imageName)
        
        
        riversRef.putData(image!, metadata: nil) { (metadata, error) in

            if error != nil {
                print("error1")
                return
            }
            riversRef.downloadURL { (url, error) in

                guard let downloadURL = url?.absoluteString else {
                    print("downloadURL error")
                    return
                }
                
                Database.database().reference().child("users").childByAutoId().setValue([
                    "userID": Auth.auth().currentUser?.email,
                    "uid": Auth.auth().currentUser?.uid,
                    "subject": self.subject.text!,
                    "context": self.context.text!,
                    "imageUrl": downloadURL,
                    "imageName": imageName,
                    "category": self.categoryText.text!,
                    "period": self.borrowPeriod.text!
                    
                ])
                self.navigationController?.popViewController(animated: true)
                //self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
//for textView placeholder
extension UploadController: UITextViewDelegate {
    func placeholderSetting() {
        context.delegate = self
        context.text = "내용을 입력하세요 :)"
        context.textColor = UIColor.lightGray
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력하세요 :)"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension UploadController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        borrowPeriod.text = pickerList[row]
    }
}
