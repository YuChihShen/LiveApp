//
//  CustomLabel.swift
//  LiveApp
//
//  Created by Class on 2022/4/5.
//

import UIKit

class CustomLabel: UILabel {
    let BorderColor = UIColor.lightGray.cgColor
    let FocusBorderColor = UIColor.darkGray.cgColor
    func initLabel(){
        self.layer.borderWidth = self.bounds.height * 0.03
        self.layer.borderColor = BorderColor
        self.layer.cornerRadius = self.bounds.midY * 0.9
    }
    func focusLabel(){
        self.layer.borderColor = FocusBorderColor
    }

}
