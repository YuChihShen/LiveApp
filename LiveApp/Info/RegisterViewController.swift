//
//  RegisterViewController.swift
//  storyboard
//
//  Created by Class on 2022/4/4.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var picPersonal: UIImageView!
    @IBOutlet weak var PhotoEditButton: UIButton!
    @IBOutlet weak var picPhotoEdit: UIImageView!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var AccountLabel: UILabel!
    @IBOutlet weak var NickNameLabel: UILabel!
    @IBOutlet weak var NickName: UITextField!
    @IBOutlet weak var Account: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Sent: UIButton!
    
    let BorderColor = UIColor.lightGray.cgColor
    let FocusBorderColor = UIColor.darkGray.cgColor
    let imagePicker = UIImagePickerController()
    let disposeBag = DisposeBag()
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if Account.isFirstResponder {AccountLabel.layer.borderColor = FocusBorderColor}
        if Password.isFirstResponder{PasswordLabel.layer.borderColor = FocusBorderColor}
        if NickName.isFirstResponder{NickNameLabel.layer.borderColor = FocusBorderColor}
        // 避免 strong password
        Password.rx.text.orEmpty.asObservable().subscribe(onNext: {
            if $0.count > 0{self.Password.isSecureTextEntry = true}
        }).disposed(by: disposeBag)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        AccountLabel.layer.borderColor = BorderColor
        PasswordLabel.layer.borderColor = BorderColor
        NickNameLabel.layer.borderColor = BorderColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        picPersonal.layer.cornerRadius = picPersonal.bounds.midY
        
        NickNameLabel.text = "暱稱"
        AccountLabel.text = "帳號"
        PasswordLabel.text = "密碼"

        Sent.setTitle("送出", for: .normal)
        Sent.layer.cornerRadius = Sent.bounds.midY
        
        PhotoEditButton.setTitle("", for: .normal)
        
        // NickNameLabel 外觀設定
        NickNameLabel.layer.borderWidth = NickNameLabel.bounds.height * 0.03
        NickNameLabel.layer.borderColor = BorderColor
        NickNameLabel.layer.cornerRadius = NickNameLabel.bounds.midY
        
        // AccountLabel 外觀設定
        AccountLabel.layer.borderWidth = AccountLabel.bounds.height * 0.03
        AccountLabel.layer.borderColor = BorderColor
        AccountLabel.layer.cornerRadius = AccountLabel.bounds.midY
        
        // PasswordLabel 外觀設定
        PasswordLabel.layer.borderWidth = PasswordLabel.bounds.height * 0.03
        PasswordLabel.layer.borderColor = BorderColor
        PasswordLabel.layer.cornerRadius = PasswordLabel.bounds.midY
    }
    override func viewDidDisappear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
               do {
                   try Auth.auth().signOut()
               } catch let error as NSError {
                   print(error.localizedDescription)
               }
           }
    }
    
    // 圖片取用訊息
    @IBAction func AlertPhoto(_ sender: Any) {
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
            self.picPersonal.image = pickerImage
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
    
    
    // 註冊
    @IBAction func Register(_ sender: Any) {
        let HeadPhotoRef = Storage.storage().reference().child(self.Account.text ?? "")
        let imageData = picPersonal.image?.jpegData(compressionQuality: 0.8)
        Auth.auth().createUser(withEmail: self.Account.text ?? "", password: self.Password.text ?? "", completion: { (user,error) in
                if error == nil {
                    HeadPhotoRef.putData(imageData!)
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.NickName.text ?? ""
                    changeRequest?.commitChanges()
                    self.navigationController?.popToRootViewController(animated: false)
                }else{
                   let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                   self.present(alert, animated: true, completion: nil)
                }
        })
    }
}
