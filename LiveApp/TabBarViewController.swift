//
//  TabBarViewController.swift
//  LiveApp
//
//  Created by Class on 2022/4/18.
//

import UIKit
import SwiftUI

class TabBarViewController: UITabBarController {
    var img1 :UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        var imageV = self.tabBar.subviews[1]
//        self.img1 = imageV.subviews[0] as! UIImageView
    }
        
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        guard let imageV = (self.tabBar.subviews[item.tag]).subviews.first as? UIImageView else { return }
        print(imageV)
        self.animate(imageView: imageV)
        
        }

    
    func animate(imageView:UIImageView){
        UIView.animate(withDuration: 1.5, delay: 0, animations: {
            imageView.transform = CGAffineTransform(rotationAngle: .pi * 1)})
    }
    
}
