//
//  TabBarViewController.swift
//  LiveApp
//
//  Created by Class on 2022/4/18.
//

import UIKit

class TabBarViewController: UITabBarController {
    var item1 : UIImageView!
    var item2 : UIImageView!
    var item3 : UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let item1 = tabBar.subviews.first?.subviews.first as? UIImageView
        //        item1 = tabBar.subviews.first as? UIImageView
//        item1.contentMode = .center
//        item1.tag = 0
//        item2 = tabBar.subviews[1] as? UIImageView
//        item3 = tabBar.subviews[2] as? UIImageView
      
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(self.item1)
//        item1 = tabBar.subviews[0] as? UIImageView
//        item2 = tabBar.subviews[1] as? UIImageView
//        item3 = tabBar.subviews[2] as? UIImageView
//        if item.tag == 1{
////        let selectedImage = UIImageView(image: tabBar.selectedItem?.selectedImage)
////        let image = UIImageView(image: tabBar.selectedItem?.image)
////        tabBar.addSubview(selectedImage)
//
//        UIView.animate(withDuration: 0.5, delay: 0, animations: {
//            self.item1.transform = CGAffineTransform(rotationAngle: .pi)
//        })
//        }
        
    }

}
