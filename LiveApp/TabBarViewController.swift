//
//  TabBarViewController.swift
//  LiveApp
//
//  Created by Class on 2022/4/18.
//

import UIKit

class TabBarViewController: UITabBarController {
    var img1 :UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        var imageV = self.tabBar.subviews[0]
//        self.img1 = imageV.subviews[0] as! UIImageView
//        item1 = tabBar.subviews.first as? UIImageView
//        item1.contentMode = .center
//        item1.tag = 0
//        item2 = tabBar.subviews[1] as? UIImageView
//        item3 = tabBar.subviews[2] as? UIImageView
    }
        
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        self.cabasicanimation.fillMode = kCAFillModeForwards;
//        self.cabasicanimation.removedOnCompletion = NO
//        let animation = CABasicAnimation
        self.animate(tag: item.tag)
//        let item1 = tabBar.subviews.first
//        let itemitem = item1?.subviews.first
//        if item.tag == 1{
//            UIView.animate(withDuration: 1.5, delay: 0, animations: {
//                self.img1.transform = CGAffineTransform(rotationAngle: .pi * 1)
//                    })
        }
    
    func animate(tag:Int){
        var imageV = self.tabBar.subviews.first
        img1 = imageV!.subviews[tag] as? UIImageView
        UIView.animate(withDuration: 1.5, delay: 0, animations: {
            self.img1.transform = CGAffineTransform(rotationAngle: .pi * 1)})
    }
    
}
