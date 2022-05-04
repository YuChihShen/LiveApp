//
//  LiveHostInfoViewController.swift
//  LiveApp
//
//  Created by yu-chih on 2022/4/29.
//

import UIKit

class LiveHostInfoViewController: UIViewController {

    @IBOutlet weak var hostInfoBG: UILabel!
    @IBOutlet weak var HostImage: UIImageView!
    
    @IBOutlet weak var HostNickname: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 0.6
        hostInfoBG.alpha = 0.1
        
        //接收 mediaView 資訊
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        let window = sceneDelegate?.window
        let mediaView = window?.rootViewController!.presentedViewController! as! MediaAVViewController
        HostImage.image = mediaView.roomHostPhoto
        HostNickname.text = mediaView.roomHostNickname
        
    }
    



}
