//
//  FireBaseSupport.swift
//  LiveApp
//
//  Created by Class on 2022/4/16.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import UIKit
import RxSwift

class FireBaseSupport{
    var userInfo = UserInfo(NickName: "", Account: "", Password: "", Memo: false, HeadPhoto: UIImage(named: "picPersonal")!)
    var userHeadPhoto = UIImage(named: "picPersonal")
    var userValid = false
    let firebaseStoreRef = Storage.storage().reference()
    var imageData = UIImage(named:"picPersonal")?.jpegData(compressionQuality: 0.8)
    let emailAdd = "@user.com"
    let db = Firestore.firestore()
    // 確認使用者
    func isUserExist()->Bool{
        if Auth.auth().currentUser != nil{
            return true
        }else{
            return false
        }
    }
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
    // firestore database 使用
    func addData(streamer_id:String){
        let ref = db.collection("\(Auth.auth().currentUser?.email ?? "")")
        ref.document("\(streamer_id)").setData(["streamer_id" : streamer_id])
    }
    func isDataExist(streamer_id:String,vc:UIViewController){
        let vc = vc as! ChatRoomViewController
        let ref = db.collection("\(Auth.auth().currentUser?.email ?? "default")").document("\(streamer_id)")
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                vc.isLiked = true
                vc.heart.isHidden = true
                vc.heartFill.isHidden = false
              
            } else {
                vc.isLiked = false
                vc.heart.isHidden = false
                vc.heartFill.isHidden = true
            }
        }
    }
    func deleteData(streamer_id:String){
        let ref = db.collection("\(Auth.auth().currentUser?.email ?? "")")
        ref.document("\(streamer_id)").delete()
    }
        
}
