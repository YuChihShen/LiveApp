//
//  LeaveAlertViewController.swift
//  LiveApp
//
//  Created by Class on 2022/4/18.
//

import UIKit
import Lottie
class LeaveAlertViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var alertBG: UILabel!
    
    @IBOutlet weak var leaveAlert: UILabel!
    let animationView = AnimationView(name: "heartbreak")
    var isAVplayerShouldTurnOff = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leaveAlert.text = NSLocalizedString("LEAVEALERT", comment: "")
        self.alertBG.clipsToBounds = true
        self.alertBG.layer.cornerRadius = 20
        
        self.setBtn(btn: leaveButton)
        self.setBtn(btn: cancelButton)
        leaveButton.setTitle(NSLocalizedString("LEAVE", comment: ""), for: .normal)
        cancelButton.setTitle(NSLocalizedString("watch for a while", comment: ""), for: .normal)
        
        animationView.frame = CGRect(x: 0, y: 0, width: 130, height: 75)
        animationView.center = CGPoint(x: self.alertBG.center.x * 0.9 , y: self.alertBG.center.y * 0.81)
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 2
        view.addSubview(animationView)
        animationView.play(fromProgress: 0, toProgress: 0.65, loopMode: .playOnce, completion: nil)
        

    }
    
    
    func setBtn(btn:UIButton){
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.clipsToBounds = true
        btn.setTitle("", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = btn.layer.frame.height / 2
    }

    @IBAction func leave(_ sender: Any) {
        animationView.animationSpeed = 1
        animationView.play(fromProgress: 0.35, toProgress: 0.75, loopMode: .playOnce){_ in

        }
        
    }
    @IBAction func cancel(_ sender: Any) {
        animationView.animationSpeed = -2
        animationView.play(fromProgress: 0, toProgress: 0.75, loopMode: .playOnce){_ in
            self.dismiss(animated: false)
        }
        
    }
    
}
