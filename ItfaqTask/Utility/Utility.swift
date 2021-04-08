//
//  Utility.swift
//  ItfaqTask
//
//  Created by Mubeena Thahir on 4/7/21.
//

import Foundation
import UIKit

class Utility : NSObject {
    
    class func isProductsLoaded() -> Bool {
        let loaded = UserDefaults.standard.bool(forKey: "PRODUCTS_LOADED")
        return loaded
    }
    
    class func isLoggedIn() -> Bool {
        let loggedin = UserDefaults.standard.bool(forKey: "LOGGED_IN")
        return loggedin
    }
    
    class func loggedInUserID() -> Int
    {
        return Int(UserDefaults.standard.integer(forKey: "LOGGED_IN_USER_ID"))
    }
    
    class func logout() {

        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = mainStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let appDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        appDelegate.window?.rootViewController = loginVC
        appDelegate.window?.makeKeyAndVisible()
        
        UserDefaults.standard.set(false, forKey: "LOGGED_IN")
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.set(Int16(0), forKey: "LOGGED_IN_USER_ID")
        UserDefaults.standard.synchronize()
    }
}
