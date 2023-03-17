//
//  AppleLoginData.swift
//  Flazhed
//
//  Created by ios2 on 22/12/21.
//
import UIKit
import Foundation
import KeychainSwift

let userIdentifierKey = "com.businesscard_userIdentifier"
let nameKey = "com.businesscard_name"
let emailKey = "com.businesscard_email"

enum LoginType:String{
    
    case credential = "credential"
    case google = "Google"
    case facebook = "Facebook"
    case apple = "Apple"
}

struct AppleLoginData {
    var userIdentifier:String!
    var name:String!
    var email:String!
    
    init(userIdentifier:String, name:String, email:String) {
        self.userIdentifier = userIdentifier
        self.name = name
        self.email = email
    }
}

let keychain = KeychainSwift()
var appleLoginData :AppleLoginData?{
    
    get{
       
        if let userIdentifier = keychain.get(userIdentifierKey),
           let name = keychain.get(nameKey),
           let email = keychain.get(emailKey){

            return AppleLoginData.init(userIdentifier:userIdentifier, name:name, email:email)
        }else{
            return nil
        }
    }
    set{

        keychain.set(newValue!.userIdentifier, forKey: userIdentifierKey)
        keychain.set(newValue!.name, forKey: nameKey)
        keychain.set(newValue!.email, forKey: emailKey)
    }
}
