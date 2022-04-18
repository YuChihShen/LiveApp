//
//  CommonUse.swift
//  LiveApp
//
//  Created by Class on 2022/4/16.
//

import Foundation
import UIKit

class PhotoPicker:UIImagePickerController{
    let fireBaseSupport = FireBaseSupport()
    var userHeadPhoto = UIImage(named: "picPersonal")
    
    func photoPickerNotification(viewController:UIViewController){
        let PhotoSelectAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        PhotoSelectAlert.view.tintColor = UIColor.gray
        // 相機
        let cameraAction = UIAlertAction(title: "開啟相機", style: .default){ _ in self.takePicture(viewController: viewController)}
        cameraAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        PhotoSelectAlert.addAction(cameraAction)
        // 相薄
        let savedPhotosAlbumAction = UIAlertAction(title: "從相簿選取", style: .default){ _ in self.openPhotosAlbum(viewController: viewController)}
        savedPhotosAlbumAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        PhotoSelectAlert.addAction(savedPhotosAlbumAction)
        // 取消
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
        PhotoSelectAlert.addAction(cancelAction)
        viewController.present(PhotoSelectAlert, animated: true, completion: nil)
    }
    // 開啟相機
    func takePicture(viewController:UIViewController) {
        self.sourceType = .camera
        viewController.present(self, animated: true)
    }
    // 開啟相簿
    func openPhotosAlbum(viewController:UIViewController) {
        self.sourceType = .savedPhotosAlbum
        viewController.present(self, animated: true)
    }
}
