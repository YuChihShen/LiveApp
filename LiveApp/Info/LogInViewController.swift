//
//  LogInViewController.swift
//  storyboard
//
//  Created by Class on 2022/4/3.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var AccountLabel: UILabel!
    @IBOutlet weak var AccountText: UITextField!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var LogInButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    
    let BorderColor = UIColor.lightGray.cgColor
    let FocusBorderColor = UIColor.darkGray.cgColor
    
    @IBAction func LogIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: AccountText.text ?? "", password: PasswordText.text ?? ""){(user,error) in
            if error == nil{
                self.tabBarController?.selectedIndex = 0
            }else{
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AccountLabel.text = "   帳號"
        PasswordLabel.text = "   密碼"
        LogInButton.setTitle("登入", for: .normal)
        RegisterButton.setTitle("註冊", for: .normal)
        RegisterButton.setTitleColor(.systemBlue, for: .normal)
       
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                self.performSegue(withIdentifier: "ShowInfo", sender: nil)
            }
        }
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
