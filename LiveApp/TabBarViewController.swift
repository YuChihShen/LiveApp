//
//  TabBarViewController.swift
//  LiveApp
//
//  Created by Class on 2022/4/18.
//

import UIKit
import SwiftUI
import CoreAudio
import Lottie

class TabBarViewController: UITabBarController,UITabBarControllerDelegate {

        override func viewDidLoad() {
            super.viewDidLoad()
            self.delegate = self
        }
        //MARK: - 點擊tabBarItem動畫效果

        override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            for (k,v) in (tabBar.items?.enumerated())! {
                if v == item {
                    animationWithIndex(index: k)
                }
            }
        }

        func animationWithIndex(index: Int){
            var tabbarbuttonArray:[Any] = [Any]()

            for tabBarBtn in self.tabBar.subviews {
                if tabBarBtn.isKind(of: NSClassFromString("UITabBarButton")!) {
                    tabbarbuttonArray.append(tabBarBtn)
                }
            }

            let pulse = CABasicAnimation(keyPath: "transform.rotation.y")
            pulse.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            pulse.duration = 0.2
            pulse.repeatCount = 1
            pulse.autoreverses = false
            pulse.fromValue = 0
            pulse.toValue = (Double.pi)
//            pulse.fillMode = CAMediaTimingFillMode.forwards
//            pulse.isRemovedOnCompletion = true



            let tabBarLayer = (tabbarbuttonArray[index] as AnyObject).layer
            tabBarLayer?.add(pulse, forKey: nil)

        }
}
