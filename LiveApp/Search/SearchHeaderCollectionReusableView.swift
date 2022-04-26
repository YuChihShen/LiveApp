//
//  SearchHeaderCollectionReusableView.swift
//  LiveApp
//
//  Created by Class on 2022/4/11.
//

import UIKit

class SearchHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var Classification: UILabel!
    var section: Int = 0
    
    func update(){
        switch section{
        case 1:
            SearchBar.isHidden = true
            SearchBar.isUserInteractionEnabled = false
            Classification.isHidden = false
            Classification.text = NSLocalizedString("SEARCH RESULT", comment: "")
        case 2:
            SearchBar.isHidden = true
            SearchBar.isUserInteractionEnabled = false
            Classification.isHidden = false
            Classification.text = NSLocalizedString("HOT", comment: "")
        default:
            Classification.isHidden = true
            SearchBar.isHidden = false
            SearchBar.isUserInteractionEnabled = true
        }
    }
}
