//
//  InteractiveTransition.swift
//  LiveApp
//
//  Created by Class on 2022/4/20.
//

import Foundation
import UIKit

class InteractiveTransition: UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {
    
    //要加手勢控制交互的UIView
    private var interactiveView: UIView!
    //當前的UIViewController
    private var presented: UIViewController!
    //當托拉超過多少%後就完成執行，否則復原
    private let thredhold: CGFloat = 0.4
    
    //不同轉場效果可能需要不同資訊，可自訂
    convenience init(_ presented: UIViewController, _ interactiveView: UIView) {
        self.init()
        self.interactiveView = interactiveView
        self.presented = presented
        setupPanGesture()
        
        //默認值，告知系統當前非交互動畫
        wantsInteractiveStart = false
    }

    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        interactiveView.addGestureRecognizer(panGesture)
    }

    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            //reset 手勢位置
            sender.setTranslation(.zero, in: interactiveView)
            //告知系統當前開始的是手勢觸發的交互動畫
            wantsInteractiveStart = true
            
            //在手勢began時呼叫要做的轉場效果(不會直接執行，系統會抓住)
            //然後轉場效果有設對應的動畫就會跳到 UIViewControllerAnimatedTransitioning 處理
            // animated 一定為 true 否則沒動畫
            
            //Dismiss:
            self.presented.dismiss(animated: true, completion: nil)
            //Present:
            //self.present(presenting,animated: true)
            //Push:
            //self.navigationController.push(presenting)
            //Pop:
            //self.navigationController.pop(animated: true)
        
        case .changed:
            //手勢滑動的位置計算 對應動畫完成百分比 0~1
            //實際依動畫類型不同，計算方式不同
            let translation = sender.translation(in: interactiveView)
            guard translation.x >= 0 else {
                sender.setTranslation(.zero, in: interactiveView)
                return
            }
            let percentage = abs(translation.x / interactiveView.bounds.height)
            
            //update UIViewControllerAnimatedTransitioning 動畫百分比
            update(percentage)
        case .ended:
            //手勢放開完成時，看完成度有沒有超過 thredhold
            wantsInteractiveStart = false
            if percentComplete >= thredhold {
              //有，告知動畫完成
              finish()
            } else {
              //無，告知動畫歸位復原
              cancel()
            }
        case .cancelled, .failed:
          //取消、錯誤時
          wantsInteractiveStart = false
          cancel()
        default:
          wantsInteractiveStart = false
          return
        }
    }
}

