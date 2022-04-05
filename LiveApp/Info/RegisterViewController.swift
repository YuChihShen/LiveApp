//
//  RegisterViewController.swift
//  storyboard
//
//  Created by Class on 2022/4/4.
//

import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var picPersonal: UIImageView!
    @IBOutlet weak var btnEdit: UIImageView!
    @IBOutlet weak var PhotoEditButton: UIButton!
    
    @IBOutlet weak var CheckPasswordLebel: UILabel!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var AccountLabel: UILabel!
    @IBOutlet weak var NickNameLabel: UILabel!
    @IBOutlet weak var NickName: UITextField!
    @IBOutlet weak var Account: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var CheckPassword: UITextField!
    
    @IBOutlet weak var Sent: UIButton!
    
    let BorderColor = UIColor.lightGray.cgColor
    let FocusBorderColor = UIColor.darkGray.cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picPersonal.layer.cornerRadius = picPersonal.bounds.midY
        
        NickNameLabel.text = "暱稱"
        AccountLabel.text = "帳號"
        PasswordLabel.text = "密碼"
        CheckPasswordLebel.text = "確認密碼"
        
        Sent.setTitle("送出", for: .normal)
        Sent.layer.cornerRadius = Sent.bounds.midY
        
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
        // CheckPasswordLebel 外觀設定
        CheckPasswordLebel.layer.borderWidth = CheckPasswordLebel.bounds.height * 0.03
        CheckPasswordLebel.layer.borderColor = BorderColor
        CheckPasswordLebel.layer.cornerRadius = CheckPasswordLebel.bounds.midY
        
        
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
        if CheckPassword.isFirstResponder{CheckPasswordLebel.layer.borderColor = FocusBorderColor}
        if NickName.isFirstResponder{NickNameLabel.layer.borderColor = FocusBorderColor}

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        AccountLabel.layer.borderColor = BorderColor
        PasswordLabel.layer.borderColor = BorderColor
        NickNameLabel.layer.borderColor = BorderColor
        CheckPasswordLebel.layer.borderColor = BorderColor
    }

}
