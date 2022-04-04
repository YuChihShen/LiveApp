//
//  RegisterViewController.swift
//  storyboard
//
//  Created by Class on 2022/4/4.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var picPersonal: UIImageView!
    @IBOutlet weak var btnEdit: UIImageView!
    @IBOutlet weak var NickName: UITextField!
    @IBOutlet weak var Account: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var CheckPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picPersonal.layer.cornerRadius = picPersonal.bounds.midY
        
    }

}
