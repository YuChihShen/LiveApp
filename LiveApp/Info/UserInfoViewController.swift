//
//  UserInfoViewController.swift
//  LiveApp
//
//  Created by Class on 2022/4/7.
//

import UIKit
import FirebaseAuth
import FirebaseStorage


class UserInfoViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate{

    @IBOutlet weak var TapButton: UIButton!
    @IBOutlet weak var LogOutButton: UIButton!
    @IBOutlet weak var AccountLabel: UILabel!
    @IBOutlet weak var NickNameLabel: UILabel!
    @IBOutlet weak var UserHeadPic: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        self.navigationItem.setHidesBackButton(true, animated: false)        
        UserHeadPic.layer.cornerRadius = UserHeadPic.bounds.midY
        // 個人訊息
        AccountLabel.text = "帳號: \(user?.email ?? "")"
        NickNameLabel.text = "暱稱: \(user?.displayName ?? "")"
        TapButton.setTitle("", for: .normal)
        LogOutButton.setTitle("登出", for: .normal)
        let HeadPhotoRef = Storage.storage().reference().child(user?.email ?? "")
        HeadPhotoRef.getData(maxSize: 2 * 1024 * 1024){(data,error)in
            if let error = error{
                print(error.localizedDescription)
            }else{
                self.UserHeadPic.image = UIImage(data: data!)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
   
    @IBAction func TapHeadPic(_ sender: Any) {
        let PhotoSelectAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        PhotoSelectAlert.view.tintColor = UIColor.gray
        // 相機
        let cameraAction = UIAlertAction(title: "開啟相機", style: .default){ _ in self.takePicture()}
        cameraAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        PhotoSelectAlert.addAction(cameraAction)
        // 相薄
        let savedPhotosAlbumAction = UIAlertAction(title: "從相簿選取", style: .default){ _ in self.openPhotosAlbum()}
        savedPhotosAlbumAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        PhotoSelectAlert.addAction(savedPhotosAlbumAction)
        // 取消
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
        PhotoSelectAlert.addAction(cancelAction)
        self.present(PhotoSelectAlert, animated: true, completion: nil)
    }
    // 取用圖片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[.originalImage] as? UIImage {
            self.UserHeadPic.image = pickerImage
        }
        let SaveRef = Storage.storage().reference().child(user?.email ?? "")
        let ImageData = self.UserHeadPic.image?.jpegData(compressionQuality: 0.6)
        let uploadTask = SaveRef.putData(ImageData!)
        uploadTask.observe(.success){(snapshot) in
            SaveRef.downloadURL{(url,error) in if
                let error = error {print("獲取圖片下載網址出現錯誤： ",error.localizedDescription)}
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = url
                changeRequest?.commitChanges()
            }
        }
        picker.dismiss(animated: true)
    }
    // 開啟相機
    func takePicture() {
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true)
    }
    // 開啟相簿
    func openPhotosAlbum() {
        imagePicker.sourceType = .savedPhotosAlbum
        self.present(imagePicker, animated: true)
    }
    @IBAction func LogOut(_ sender: Any) {
        if Auth.auth().currentUser != nil {
               do {
                   try Auth.auth().signOut()
                   self.navigationController?.popToRootViewController(animated: true)
               } catch let error as NSError {
                   print(error.localizedDescription)
               }
           }
    }

}

