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
    @IBOutlet weak var passwordAppear: UIImageView!
    @IBOutlet weak var passwordHidden: UIImageView!
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
    
    @IBOutlet weak var PasswordAppearSwitch: UIButton!
    var keyboardHeight: CGFloat = 0
    let photoPicker = PhotoPicker()
    let fireBaseSupport = FireBaseSupport()
    let BorderColor = UIColor.lightGray.cgColor
    let FocusBorderColor = UIColor.darkGray.cgColor
    var accountValid = false
    var passwordValid = false
    var nicknameValid = false
    @IBOutlet weak var viewElement: UIView!
    @IBOutlet weak var viewConstraintY: NSLayoutConstraint!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PasswordAppearSwitch.setTitle("", for: .normal)
        let labelHidden = true
        accountNote.isHidden = labelHidden
        passwordNote.isHidden = labelHidden
        self.nicknameNote.textColor = .systemGreen
        Sent.isEnabled = false
        
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
        
        passwordHidden.isHidden = false
        passwordAppear.isHidden = true
        Password.isSecureTextEntry = true
        
    }
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
    // 取消編輯
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // return 事件
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         if textField == self.NickName {
             self.NickName.resignFirstResponder()
             self.Account.becomeFirstResponder()
         }else if textField == self.Account{
             self.Password.becomeFirstResponder()
         }else{
             self.resignFirstResponder()
         }
         return true
    }
    // 編輯事件
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        let accountRegex = "^[0-9A-Za-z]{4,20}$"
        let passwordRegex = "^[0-9A-Za-z]{6,12}$"
        let accountCompareResult = try? NSRegularExpression(pattern: accountRegex).numberOfMatches(in: Account.text ?? "", options: .reportProgress, range: NSRange(location: 0, length: Account.text?.count ?? 0))
        let passwordCompareResult = try? NSRegularExpression(pattern: passwordRegex).numberOfMatches(in: Password.text ?? "", options: .reportProgress, range: NSRange(location: 0, length: Password.text?.count ?? 0))
        
        // 帳號驗證
        let accountString = Account.text ?? ""
        if accountString.count > 0 && (accountString.count < 4 || accountString.count > 20) {
            self.accountNote.text = "請輸入 4 - 20 位字母或數字"
            self.accountNote.textColor = .systemGreen
            self.accountValid = false
        }else if accountCompareResult == 0 {
            self.accountNote.text = "帳號格式錯誤"
            self.accountNote.textColor = .systemPink
            self.accountValid = false
        }else{
            self.accountNote.text = "帳號格式正確"
            self.accountNote.textColor = .systemGreen
            self.accountValid = true
        }
        // 密碼驗證
        let passwordStrig = Password.text ?? ""
        if accountString.count > 0 && (passwordStrig.count < 6 || passwordStrig.count > 12) {
            self.passwordNote.text = "請輸入 6 - 12 位字母或數字"
            self.passwordNote.textColor = .systemGreen
            self.passwordValid = false
        }else if passwordCompareResult == 0 {
            self.passwordNote.text = "密碼格式錯誤"
            self.passwordNote.textColor = .systemPink
            self.passwordValid = false
        }else{
            self.passwordNote.text = "密碼格式正確"
            self.passwordNote.textColor = .systemGreen
            self.passwordValid = true
        }
        // 暱稱
        if (self.NickName.text ?? "").count != 0 {
            self.nicknameNote.text = ""
            self.nicknameValid = true
            self.nicknameNote.isHidden = true
        }else{
            self.nicknameNote.text = "暱稱不可為空值"
            self.nicknameValid = false
            self.nicknameNote.isHidden = false
        }
        if accountValid && passwordValid && nicknameValid {
            self.Sent.isEnabled = true
        }else{
            self.Sent.isEnabled = false
        }
        if accountString.count == 0 {
            self.accountNote.isHidden = true
        }else{
            self.accountNote.isHidden = false
        }
        if passwordStrig.count == 0 {
            self.passwordNote.isHidden = true
        }else{
            self.passwordNote.isHidden = false
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if Account.isFirstResponder {
            AccountLabel.layer.borderColor = FocusBorderColor
                self.viewElement.center =
                CGPoint(x: self.view.center.x, y: self.viewElement.center.y * 0.85 )
        }
        if Password.isFirstResponder{
            PasswordLabel.layer.borderColor = FocusBorderColor
                self.viewElement.center =
                CGPoint(x: self.view.center.x, y: self.viewElement.center.y * 0.7)
        }
        if NickName.isFirstResponder{
            NickNameLabel.layer.borderColor = FocusBorderColor
        }
        self.viewConstraintY.constant = self.viewElement.center.y - self.view.center.y
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        AccountLabel.layer.borderColor = BorderColor
        PasswordLabel.layer.borderColor = BorderColor
        NickNameLabel.layer.borderColor = BorderColor
        self.viewElement.center =
        CGPoint(x: self.view.center.x, y: self.view.center.y )
        self.viewConstraintY.constant = 0
    }
    //密碼是否可視
    @IBAction func passwordAppear(_ sender: Any) {
        passwordAppear.isHidden.toggle()
        passwordHidden.isHidden.toggle()
        self.Password.isSecureTextEntry.toggle()
    }

}
