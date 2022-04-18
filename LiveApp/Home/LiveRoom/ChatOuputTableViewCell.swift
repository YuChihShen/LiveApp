//
//  ChatOuputTableViewCell.swift
//  LiveApp
//
//  Created by Class on 2022/4/13.
//

import UIKit

class ChatOuputTableViewCell: UITableViewCell {

    @IBOutlet weak var ContentText: UILabel!
    @IBOutlet weak var UserNameText: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
