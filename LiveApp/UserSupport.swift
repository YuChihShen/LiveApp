//
//  UserSupport.swift
//  LiveApp
//
//  Created by Class on 2022/4/17.
//

import Foundation
import RxCocoa
import RxSwift

class UserSupport{
    let accountValid: Observable<Bool>
    let passwordValid: Observable<Bool>
    let actionValid: Observable<Bool>
    let accountRegex = "(?=.*[0-9])(?=.*[a-z])^[0-9A-Za-z]{4,20}$"
    let passwordRegex = "(?=.*[0-9])(?=.*[a-z])^[0-9A-Za-z]{6,12}$"
    
    init(account: Observable<String>,password: Observable<String>){
        
            accountValid = account
                .map { $0.count >= 5 }
                .share(replay: 1)

            passwordValid = password
                .map { $0.count >= 5 }
                .share(replay: 1)

            actionValid = Observable.combineLatest(accountValid, passwordValid) { $0 && $1 }
                .share(replay: 1)
        
    }
    func verifyMethold(regex:String,text:String)->Bool{
        let result = try? NSRegularExpression(pattern: regex).numberOfMatches(in: text, range: NSRange(location: 0, length: text.utf16.count))
        if result != 0 {
            return true
        }else{
            return false
        }
    }
    
}
