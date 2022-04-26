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

class MediaAVViewController: AVPlayerViewController, UIGestureRecognizerDelegate {
    let bag = DisposeBag()
    var videoPath = ""
    var looper: AVPlayerLooper?
    let playerItem = URL(fileURLWithPath: Bundle.main.path(forResource: "hime3", ofType: "mp4")!)
    let streamItem = URL(string: "http://samples.mplayerhq.hu/V-codecs/h264/interlaced_crop.mp4")
   
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
           return .portrait
       }
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = AVPlayerItem(url: playerItem)
        let player = AVQueuePlayer()
        looper = AVPlayerLooper(player: player, templateItem: item)
//        let player = AVPlayer.init(url: streamItem!)
        self.player = player
        self.showsPlaybackControls = true
        videoGravity = AVLayerVideoGravity.resizeAspectFill
        player.play()
    }
    // ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        self.transChatRoom()
    }
    func transChatRoom(){
        let chatRoom = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoom")
        chatRoom?.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.present(chatRoom!, animated: false, completion: nil)
    }    
    func test(){
        self.dismiss(animated: true)
    }
    @IBAction func unwindToSelf(segue:UIStoryboardSegue) {
        let sourceVC = segue.source as? LeaveAlertViewController
        if sourceVC?.isAVplayerShouldTurnOff == true{
                self.dismiss(animated: false)

        }
    }
//    private func setupPanGesture() {
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        panGesture.maximumNumberOfTouches = 1
//        panGesture.delegate = self
//        self.view.addGestureRecognizer(panGesture)
//    }
//
//    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
//        switch sender.state {
//        case .began:
//            //reset 手勢位置
//            sender.setTranslation(.zero, in: self.view)
//            //告知系統當前開始的是手勢觸發的交互動畫
////            self.wantsInteractiveStart = true
//            
//            //present:
//            let chatRoom = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoom")
//            chatRoom?.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
//            self.present(chatRoom!, animated: true, completion: nil)
//        
//        case .changed:
//            //手勢滑動的位置計算 對應動畫完成百分比 0~1
//            //實際依動畫類型不同，計算方式不同
//            let translation = sender.translation(in: self.view)
//            guard translation.x <= 0 else {
//                sender.setTranslation(.zero, in: self.view)
//                return
//            }
//            let percentage = abs(translation.x / self.view.bounds.height)
//            
//            //update UIViewControllerAnimatedTransitioning 動畫百分比
//            update(percentage)
//        case .ended:
//            //手勢放開完成時，看完成度有沒有超過 thredhold
////            wantsInteractiveStart = false
//            if percentComplete >= thredhold {
//              //有，告知動畫完成
//              finish()
//            } else {
//              //無，告知動畫歸位復原
//              cancel()
//            }
//        case .cancelled, .failed:
//          //取消、錯誤時
//          wantsInteractiveStart = false
//          cancel()
//        default:
//          wantsInteractiveStart = false
//          return
//        }
//    }

}
