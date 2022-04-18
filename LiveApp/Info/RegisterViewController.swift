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

    @IBOutlet weak var userHeadPhoto: UIImageView!
    @IBOutlet weak var PhotoEditButton: UIButton!
    @IBOutlet weak var picPhotoEdit: UIImageView!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var AccountLabel: UILabel!
    @IBOutlet weak var NickNameLabel: UILabel!
    @IBOutlet weak var NickName: UITextField!
    @IBOutlet weak var Account: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Sent: UIButton!
    
    @IBOutlet weak var accountNote: UILabel!
    @IBOutlet weak var nicknameNote: UILabel!
    @IBOutlet weak var passwordNote: UILabel!
    
    var userSupport:UserSupport!
    let photoPicker = PhotoPicker()
    let fireBaseSupport = FireBaseSupport()
    let BorderColor = UIColor.lightGray.cgColor
    let FocusBorderColor = UIColor.darkGray.cgColor
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let accountOB = Account.rx.text.orEmpty.asObservable()
        let passwordOB = Password.rx.text.orEmpty.asObservable()
        let labelHidden = true
        accountNote.isHidden = labelHidden
        passwordNote.isHidden = labelHidden
        nicknameNote.isHidden = labelHidden
        
        userSupport = UserSupport(account: accountOB, password: passwordOB)
        
//        userSupport.accountValid
//                   .bind(to: accountNote.rx.isHidden)
//                   .disposed(by: bag)
        
        setLabel(label: NickNameLabel)
        setLabel(label: AccountLabel)
        setLabel(label: PasswordLabel)
        userHeadPhoto.layer.cornerRadius = userHeadPhoto.bounds.height / 2
        
        NickNameLabel.text = "暱稱"
        AccountLabel.text = "帳號"
        PasswordLabel.text = "密碼"

        Sent.setTitle("送出", for: .normal)
        Sent.layer.cornerRadius = Sent.bounds.midY
        PhotoEditButton.setTitle("", for: .normal)
        
        
    }
//    override func viewDidDisappear(_ animated: Bool) {
//        if Auth.auth().currentUser != nil {
//               do {
//                   try Auth.auth().signOut()
//               } catch let error as NSError {
//                   print(error.localizedDescription)
//               }
//           }
//    }
    func setLabel(label:UILabel){
        label.layer.borderWidth = label.bounds.height * 0.03
        label.layer.cornerRadius = label.bounds.height / 2
        label.layer.borderColor = BorderColor
    }
    
    // 圖片取用訊息
    @IBAction func AlertPhoto(_ sender: Any) {
        self.photoPicker.delegate = self
        self.photoPicker.photoPickerNotification(viewController: self)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[.originalImage] as? UIImage {
            self.userHeadPhoto.image = pickerImage
        }
        picker.dismiss(animated: true)
    }
    // 註冊
    @IBAction func Register(_ sender: Any) {
        self.fireBaseSupport
            .createUser(account: self.Account.text!, password: self.Password.text!, nickname: self.NickName.text!, image: self.userHeadPhoto.image!, vc: self)
    }
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
        }).disposed(by: bag)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        AccountLabel.layer.borderColor = BorderColor
        PasswordLabel.layer.borderColor = BorderColor
        NickNameLabel.layer.borderColor = BorderColor
    }
}
