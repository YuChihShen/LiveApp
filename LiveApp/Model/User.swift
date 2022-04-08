//
//  User.swift
//  LiveApp
//
//  Created by Class on 2022/4/7.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    let NickName: String
    let Account: String
    let PhotoURL: String
}
