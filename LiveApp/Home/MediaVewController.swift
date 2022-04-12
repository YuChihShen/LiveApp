//
//  MediaAVViewController.swift
//  LiveApp
//
//  Created by Class on 2022/4/10.
//

import UIKit
import AVKit
import AVFoundation
import RxCocoa
import RxSwift
class MediaAVViewController: AVPlayerViewController {
    let bag = DisposeBag()
    var videoPath = ""
    let playerItem = URL(fileURLWithPath: Bundle.main.path(forResource: "hime3", ofType: "mp4")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoGravity = AVLayerVideoGravity.resizeAspectFill
        player = AVPlayer(url: playerItem)
        player?.actionAtItemEnd = .pause
        player?.play()
        
        addLeaveButton()
        
    }
    func addLeaveButton(){
        let button = UIButton()
        let buttonSize = view.frame.height * 0.06
        button.frame.size = CGSize(width: buttonSize, height: buttonSize )
        button.center = CGPoint(x: view.frame.midX * 1.8, y: view.frame.midY * 0.3)
        button.layer.cornerRadius = button.bounds.midY
        button.layer.backgroundColor = UIColor.darkGray.cgColor
        button.setTitle(nil, for: .normal)
        button.setImage(UIImage(named: "logout"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.rx.tap.subscribe(onNext: { _ in
                    print("click")
                    self.leaveAlert()
                })
                .disposed(by: bag)
        self.contentOverlayView?.addSubview(button)
    }
    func leaveAlert(){
        
        let LeaveRoomAlert = UIAlertController(title: nil, message: String(repeating: "\n", count: 6), preferredStyle: .alert)
        LeaveRoomAlert.view.tintColor = UIColor.white
        
        // 離開
        let leaveAction = UIAlertAction(title: "離開", style: .default){ _ in
            self.dismiss(animated: false)
        }
        leaveAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        // 取消
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        cancelAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        // addAction
//        LeaveRoomAlert.addAction(leaveAction)
//        LeaveRoomAlert.addAction(cancelAction)

        self.present(LeaveRoomAlert, animated: true, completion: nil)
    }
    

}
