//
//  UserInfoViewController.swift
//  LiveApp
//
//  Created by Class on 2022/4/7.
//

import UIKit
import FirebaseAuth
import FirebaseStorage


class UserInfoViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate,UITextFieldDelegate{

    @IBOutlet weak var TapButton: UIButton!
    @IBOutlet weak var LogOutButton: UIButton!
    @IBOutlet weak var AccountLabel: UILabel!
    @IBOutlet weak var NickNameLabel: UILabel!
    @IBOutlet weak var UserHeadPic: UIImageView!
    
    @IBOutlet weak var infoEditButton: UIButton!
    @IBOutlet weak var infoEditTextfield: UITextField!
    let imagePicker = UIImagePickerController()
    let user = Auth.auth().currentUser
    let photoPicker = PhotoPicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.infoEditButton.setTitle("", for: .normal)
        self.infoEditTextfield.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: false)        
        UserHeadPic.layer.cornerRadius = UserHeadPic.bounds.midY
        // 個人訊息
        let accountString = user?.email ?? ""
        let userAccount = accountString.components(separatedBy: "@")
        AccountLabel.text = "帳號: \(userAccount[0])"
        NickNameLabel.text = "暱稱: \(user?.displayName ?? "")"
        TapButton.setTitle("", for: .normal)
        LogOutButton.setTitle("登出", for: .normal)
        
        // 取得頭貼 Ref
        let HeadPhotoRef = Storage.storage().reference().child(user?.email ?? "")
        // 下載頭貼
        HeadPhotoRef.getData(maxSize: 2 * 1024 * 1024){(data,error)in
            if let error = error{
                print(error.localizedDescription)
            }else{
                self.UserHeadPic.image = UIImage(data: data!)
            }
        }
    }
    
   
    @IBAction func TapHeadPic(_ sender: Any) {
        self.photoPicker.delegate = self
        self.photoPicker.photoPickerNotification(viewController: self)
    }
    // 取用圖片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[.originalImage] as? UIImage {
            self.UserHeadPic.image = pickerImage
        }
        // 上傳頭貼
        let SaveRef = Storage.storage().reference().child(user?.email ?? "")
        let ImageData = self.UserHeadPic.image?.jpegData(compressionQuality: 0.6)
        print("OK")
        SaveRef.putData(ImageData!)
        picker.dismiss(animated: true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.infoEditTextfield.isHidden = true
        if self.infoEditTextfield.text?.count != 0 {
            let nicknameEditAlert =
            UIAlertController(title: "確定更改暱稱？", message: "新暱稱為：\(self.infoEditTextfield.text ?? "")", preferredStyle: .alert)
            nicknameEditAlert.view.tintColor = UIColor.gray
            let okAction = UIAlertAction(title: "確定更改", style: .default){_ in
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self.infoEditTextfield.text
                changeRequest?.commitChanges()
                self.NickNameLabel.text = "暱稱: \(self.infoEditTextfield.text ?? "")"
                self.infoEditTextfield.text = nil
                self.dismiss(animated: false)
            }
            okAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
            nicknameEditAlert.addAction(okAction)
            let cancelAction = UIAlertAction(title: "取消", style: .default){_ in
                self.infoEditTextfield.text = nil
                self.dismiss(animated: false)
            }
            cancelAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
            nicknameEditAlert.addAction(cancelAction)
            self.present(nicknameEditAlert, animated: true, completion: nil)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    @IBAction func editNickname(_ sender: Any) {
        self.infoEditTextfield.isHidden = false
        self.infoEditTextfield.text = ""
        self.infoEditTextfield.becomeFirstResponder()
    }
    // 登出
    @IBAction func LogOut(_ sender: Any) {
        if Auth.auth().currentUser != nil {
               do {
                   try Auth.auth().signOut()
                   self.navigationController?.viewDidLoad()
               } catch let error as NSError {
                   print(error.localizedDescription)
               }
           }
    }

}

