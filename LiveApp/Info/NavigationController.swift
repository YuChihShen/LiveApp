//
//  NavigationController.swift
//  LiveApp
//
//  Created by Class on 2022/4/10.
//

import UIKit
import FirebaseAuth

class NavigationController: UINavigationController {


    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            let ViewInfo = self.storyboard?.instantiateViewController(withIdentifier: "UserInfo")
            self.viewControllers = [ViewInfo!]
        }else{
            let ViewLogIn = self.storyboard?.instantiateViewController(withIdentifier: "LogInView")
            self.viewControllers = [ViewLogIn!]
        }
    }
    

 

}
