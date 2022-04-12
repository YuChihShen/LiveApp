//
//  HeaderCollectionReusableView.swift
//  LiveApp
//
//  Created by Class on 2022/4/9.
//

import UIKit
import FirebaseStorage

class HeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var UserNickName: UILabel!
    @IBOutlet weak var UserHeadPhoto: UIImageView!
    
    var userNickName = ""
    var userEmail = ""
    
    func update(){
        UserHeadPhoto.layer.cornerRadius = UserHeadPhoto.bounds.midY
        self.UserNickName.text = userNickName
        let imageRef = Storage.storage().reference().child(userEmail)
        imageRef.getData(maxSize: 3 * 1024 * 1024){(data,error)in
            if let error = error{
                print(error.localizedDescription)
            }else{
                self.UserHeadPhoto.image = UIImage(data: data!)!
            }
        }
    }
    
    
}
