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
    
    var roomHostPhoto = UIImage(named: "")
    var roomHostNickname = ""
    var streamer_id = 0
    var isChatRoomExist = false
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
           return .portrait
       }
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showsPlaybackControls = false
        videoGravity = AVLayerVideoGravity.resizeAspectFill
//        let item = AVPlayerItem(url: streamItem!)
        let item = AVPlayerItem(url: playerItem)
        let player = AVQueuePlayer()
        looper = AVPlayerLooper(player: player, templateItem: item)
        self.player = player
        player.play()
        if isChatRoomExist == true{
            let chatRoom = self.presentedViewController as! ChatRoomViewController
            chatRoom.leaveRoom()
            chatRoom.viewDidLoad()
//            self.transChatRoom()
        }
    }
    // ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        
        self.transChatRoom()
        
    }
    func playVideo(status:Int){
//        let item = AVPlayerItem(url: streamItem!)
        let item = AVPlayerItem(url: playerItem)
        let player = AVQueuePlayer()
        looper = AVPlayerLooper(player: player, templateItem: item)
        self.player = player
        switch status{
        case 0:
            player.play()
        case 1:
            player.pause()
        case 2:
            self.player = nil
        default:
            ()
        }
        player.play()
        
    }
    func stopVideo(){
        self.player = nil
    }
    
    func transChatRoom(){
        let chatRoom = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoom") as! ChatRoomViewController
        chatRoom.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.present(chatRoom, animated: false, completion: nil)
        
    }
    @IBAction func unwindToSelf(segue:UIStoryboardSegue) {
        let sourceVC = segue.source as? LeaveAlertViewController
        if sourceVC?.isAVplayerShouldTurnOff == true{
                self.dismiss(animated: false)

        }
    }
    

}
