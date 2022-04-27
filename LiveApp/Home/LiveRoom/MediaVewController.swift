//
//  MediaAVViewController.swift
//  LiveApp
//
//  Created by Class on 2022/4/10.
//

import UIKit
import AVKit
import AVFoundation

class MediaAVViewController: AVPlayerViewController, UIGestureRecognizerDelegate {
    var videoPath = ""
    var looper: AVPlayerLooper?
    let playerItem = URL(fileURLWithPath: Bundle.main.path(forResource: "hime3", ofType: "mp4")!)
    let streamItem = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
           return .portrait
       }
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("streamItem:\(streamItem!)")
        let item = AVPlayerItem(url: streamItem!)
        print("item:\(item)")
        let player = AVQueuePlayer()
        looper = AVPlayerLooper(player: player, templateItem: item)
        
        self.player = player
        self.showsPlaybackControls = false
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
    @IBAction func unwindToSelf(segue:UIStoryboardSegue) {
        let sourceVC = segue.source as? LeaveAlertViewController
        if sourceVC?.isAVplayerShouldTurnOff == true{
                self.dismiss(animated: false)

        }
    }
    

}
