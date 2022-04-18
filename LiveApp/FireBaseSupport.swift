//
//  FireBaseSupport.swift
//  LiveApp
//
//  Created by Class on 2022/4/16.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import UIKit
import RxSwift

class FireBaseSupport{
    var userInfo = UserInfo(NickName: "", Account: "", Password: "", Memo: false, HeadPhoto: UIImage(named: "picPersonal")!)
    var userHeadPhoto = UIImage(named: "picPersonal")
    var userValid = false
    let firebaseStoreRef = Storage.storage().reference()
    var imageData = UIImage(named:"picPersonal")?.jpegData(compressionQuality: 0.8)
    let emailAdd = "@user.com"
    
    // 確認使用者
   
    // 建立使用者
    func createUser(account:String,password:String,nickname:String,image:UIImage,vc:UIViewController){
        let email = account + emailAdd
        self.imageData = image.jpegData(compressionQuality: 0.6)
        
        var err = ""
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user,error) in
                if error == nil {
                    self.firebaseStoreRef.child(email).putData(self.imageData!)
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = nickname
                    changeRequest?.commitChanges()
                    vc.navigationController?.popToRootViewController(animated: false)
                }else{
                    err = error?.localizedDescription ?? ""
                    print("err:\(err)")
                    let alert = UIAlertController(title: "Error", message: err, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    vc.present(alert, animated: true, completion: nil)
                }
        })
    }
        
}
