//
//  LogInViewController.swift
//  storyboard
//
//  Created by Class on 2022/4/3.
//

import UIKit

class LogInViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var NavBar: UINavigationBar!
    @IBOutlet weak var AccountLabel: UILabel!
    @IBOutlet weak var AccountText: UITextField!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var LogInButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    
    let BorderColor = UIColor.lightGray.cgColor
    let FocusBorderColor = UIColor.darkGray.cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AccountLabel.text = "   帳號"
        PasswordLabel.text = "   密碼"
        LogInButton.setTitle("登入", for: .normal)
        RegisterButton.setTitle("註冊", for: .normal)
        RegisterButton.setTitleColor(.black, for: .normal)
       
        // AccountLabel 外觀設定
        AccountLabel.layer.borderWidth = AccountLabel.bounds.height * 0.03
        AccountLabel.layer.borderColor = BorderColor
        AccountLabel.layer.cornerRadius = AccountLabel.bounds.midY
        
        // PasswordLabel 外觀設定
        PasswordLabel.layer.borderWidth = PasswordLabel.bounds.height * 0.03
        PasswordLabel.layer.borderColor = BorderColor
        PasswordLabel.layer.cornerRadius = PasswordLabel.bounds.midY 
        
        // LoginButton 外觀設定
        LogInButton.layer.backgroundColor = UIColor.black.cgColor
        LogInButton.layer.cornerRadius = LogInButton.bounds.midY
        
        
        
        
       
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if AccountText.isFirstResponder {AccountLabel.layer.borderColor = FocusBorderColor}
        if PasswordText.isFirstResponder{PasswordLabel.layer.borderColor = FocusBorderColor}
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        AccountLabel.layer.borderColor = BorderColor
        PasswordLabel.layer.borderColor = BorderColor
    }
}
