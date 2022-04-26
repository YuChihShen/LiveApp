//
//  LogInViewController.swift
//  storyboard
//
//  Created by Class on 2022/4/3.
//

import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa
import Lottie

class LogInViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var memoImage: UIImageView!
    @IBOutlet weak var memo: UILabel!
    @IBOutlet weak var AccountLabel: UILabel!
    @IBOutlet weak var AccountText: UITextField!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var LogInButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var AccountNote: UILabel!
    
    @IBOutlet weak var memoButton: UIButton!
    @IBOutlet weak var passwordAppearSwitch: UIButton!
    @IBOutlet weak var passwordHidden: UIImageView!
    @IBOutlet weak var passwordAppear: UIImageView!
    @IBOutlet weak var PasswordNote: UILabel!
    let BorderColor = UIColor.lightGray.cgColor
    let FocusBorderColor = UIColor.darkGray.cgColor
    let userdefault = UserDefaults()
    let disposeBag = DisposeBag()
    var user = Auth.auth().currentUser
    var accountValid = false
    var passwordValid = false
    var memoColor = false
    
    @IBAction func LogIn(_ sender: Any) {
        let accountEmail = ("\(self.AccountText.text!)@user.com")
        Auth.auth().signIn(withEmail: accountEmail, password: PasswordText.text ?? ""){(user,error) in
            if error == nil{
                self.tabBarController?.selectedIndex = 0
                self.navigationController?.viewDidLoad()
                print(self.memoColor)
                if self.memoColor == true {
                    self.userdefault.set("\(self.AccountText.text!)", forKey: "account")
                    self.userdefault.set("\(self.PasswordText.text!)", forKey: "password")
                    self.userdefault.set(true, forKey: "memo")
                }else{
                    self.userdefault.set("", forKey: "account")
                    self.userdefault.set("", forKey: "password")
                    self.userdefault.set(false, forKey: "memo")
                }
                
            }else{
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
               do {
                   try Auth.auth().signOut()
               } catch let error as NSError {
                   print(error.localizedDescription)
               }
           }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("SIGNIN PAGE", comment: "")
        self.AccountText.placeholder = NSLocalizedString("Please enter 4 - 20 letters or numbers", comment: "")
        self.PasswordText.placeholder = NSLocalizedString("Please enter 6 - 12 letters or numbers", comment: "")
        
        self.memoButton.setTitle("", for: .normal)
        self.memo.textColor = .lightGray
        self.memoImage.tintColor = .lightGray
       
        self.memoColor = UserDefaults.standard.bool(forKey: "memo")
        
        AccountLabel.text = NSLocalizedString("ACCOUNT", comment: "")
        PasswordLabel.text = NSLocalizedString("PASSWORD", comment: "")
        LogInButton.setTitle( NSLocalizedString("SIGNIN", comment: ""), for: .normal)
        RegisterButton.setTitle(NSLocalizedString("SIGNUP", comment: ""), for: .normal)
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
        LogInButton.layer.cornerRadius = LogInButton.bounds.midY
        
        passwordHidden.isHidden = false
        passwordAppear.isHidden = true
        PasswordText.isSecureTextEntry = true
        passwordAppearSwitch.setTitle("", for: .normal)
        
        let labelHidden = true
        AccountNote.isHidden = labelHidden
        PasswordNote.isHidden = labelHidden
        LogInButton.isEnabled = false
      
        memo.text = NSLocalizedString("REMEMBER", comment: "")
        if memoColor == true{
            self.memo.textColor = .systemGreen
            self.memoImage.tintColor = .systemGreen
            let accountText = (UserDefaults.standard.value(forKey: "account"))
            let passwordText =  (UserDefaults.standard.string(forKey: "password"))
            let accountTitle = (accountText! as! String).components(separatedBy: "@")
            self.AccountText.text = accountTitle[0]
            self.PasswordText.text = passwordText
            self.LogInButton.isEnabled = true
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
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let accountRegex = "^[0-9A-Za-z]{4,20}$"
        let passwordRegex = "^[0-9A-Za-z]{6,12}$"
        let accountCompareResult = try? NSRegularExpression(pattern: accountRegex).numberOfMatches(in: AccountText.text ?? "", options: .reportProgress, range: NSRange(location: 0, length: AccountText.text?.count ?? 0))
        let passwordCompareResult = try? NSRegularExpression(pattern: passwordRegex).numberOfMatches(in: PasswordText.text ?? "", options: .reportProgress, range: NSRange(location: 0, length: PasswordText.text?.count ?? 0))
        
        // 帳號驗證
        let accountString = AccountText.text ?? ""
        if accountString.count > 0 && (accountString.count < 4 || accountString.count > 20) {
            self.AccountNote.text = NSLocalizedString("Please enter 4 - 20 letters or numbers", comment: "")
            self.AccountNote.textColor = .systemGreen
            self.accountValid = false
        }else if accountCompareResult == 0 {
            self.AccountNote.text = NSLocalizedString("wrong format for account", comment: "")
            self.AccountNote.textColor = .systemPink
            self.accountValid = false
        }else{
            self.AccountNote.text = NSLocalizedString("correct format for account", comment: "")
            self.AccountNote.textColor = .systemGreen
            self.accountValid = true
        }
        // 密碼驗證
        let passwordStrig = PasswordText.text ?? ""
        if accountString.count > 0 && (passwordStrig.count < 6 || passwordStrig.count > 12) {
            self.PasswordNote.text = NSLocalizedString("Please enter 6 - 12 letters or numbers", comment: "")
            self.PasswordNote.textColor = .systemGreen
            self.passwordValid = false
        }else if passwordCompareResult == 0 {
            self.PasswordNote.text = NSLocalizedString("wrong format for password", comment: "")
            self.PasswordNote.textColor = .systemPink
            self.passwordValid = false
        }else{
            self.PasswordNote.text = NSLocalizedString("correct format for password", comment: "")
            self.PasswordNote.textColor = .systemGreen
            self.passwordValid = true
        }
        
        if accountValid && passwordValid {
            self.LogInButton.isEnabled = true
//            self.LogInButton.layer.backgroundColor = UIColor.black.cgColor
        }else{
            self.LogInButton.isEnabled = false
        }
        if accountString.count == 0 {
            self.AccountNote.isHidden = true
        }else{
            self.AccountNote.isHidden = false
        }
        if passwordStrig.count == 0 {
            self.PasswordNote.isHidden = true
        }else{
            self.PasswordNote.isHidden = false
        }
    }
    
    @IBAction func memoMe(_ sender: Any) {
        if memoColor == false{
            self.memo.textColor = .systemGreen
            self.memoImage.tintColor = .systemGreen
            self.memoColor.toggle()
            
        }else{
            self.memo.textColor = .lightGray
            self.memoImage.tintColor = .lightGray
            self.memoColor.toggle()
        }
    }
    @IBAction func passwordSwitch(_ sender: Any) {
        passwordAppear.isHidden.toggle()
        passwordHidden.isHidden.toggle()
        self.PasswordText.isSecureTextEntry.toggle()
    }
}
