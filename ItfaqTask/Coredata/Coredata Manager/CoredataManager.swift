//
//  CoredataManager.swift
//  ItfaqTask
//
//  Created by Mubeena Thahir on 4/7/21.
//

import UIKit
import CoreData

class CoredataManager: NSObject {

    class func fetchEntity(entity entityName : String, andPredicate predicate:NSPredicate?, limit : Int = 0, sortDescriptors : [NSSortDescriptor]? = nil) -> Array<Any>?
    {
        let appDelegate:AppDelegate = {
            return UIApplication.shared.delegate as! AppDelegate
        }()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        var errorPointer: NSError?;
        fetchRequest.predicate = predicate
        if limit > 0
        {
            fetchRequest.fetchLimit = limit
        }
        if sortDescriptors != nil
        {
            fetchRequest.sortDescriptors = sortDescriptors
        }
        
        do
        {
            let fetchResults = try appDelegate.managedObjectContext!.fetch(fetchRequest)
            if fetchResults.count > 0 {
                return fetchResults
            }
            else {
                return nil
            }
        }
        catch let error as NSError
        {
            errorPointer = error
            print(errorPointer as Any)
            return nil
        }
    }

    class func insertProducts(products : [D_Product])
    {
        let appDelegate:AppDelegate = {
            return UIApplication.shared.delegate as! AppDelegate
        }()
        
        for pdt in products {
            let insertPdt = NSEntityDescription.insertNewObject(forEntityName: "Product", into: appDelegate.managedObjectContext!) as! Product
            insertPdt.id = Int16(pdt.id)
            insertPdt.title = pdt.title
            insertPdt.desc = pdt.description
            insertPdt.price = pdt.price
            insertPdt.image = pdt.image
            insertPdt.category = pdt.category
        }
        
        appDelegate.saveContext()
    }
    
    class func insertUser(user : D_User)
    {
        if (CoredataManager.fetchEntity(entity: "User", andPredicate: NSPredicate(format: "id == \(user.id)"))?.first) != nil {
            return
        }
        
        let appDelegate:AppDelegate = {
            return UIApplication.shared.delegate as! AppDelegate
        }()
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: appDelegate.managedObjectContext!) as! User
        newUser.id = Int16(user.id)
        newUser.username = user.username
        newUser.password = user.password
        
        appDelegate.saveContext()
        
        let newCart = NSEntityDescription.insertNewObject(forEntityName: "Cart", into: appDelegate.managedObjectContext!) as! Cart
        newCart.userId = Int16(user.id)
        newCart.cartItems = NSSet()
        appDelegate.saveContext()
    }
    
    class func addToCart(userId : Int16, productId : Int16) {
        
        let appDelegate:AppDelegate = {
            return UIApplication.shared.delegate as! AppDelegate
        }()
        
        if CoredataManager.getCartItem(userId: userId, productId: productId) != nil {
            CoredataManager.incrementQuantity(userId: userId, productId: productId)
        } else {
            if let cart = getCartForUser(userid : userId) {
                let cartItem = NSEntityDescription.insertNewObject(forEntityName: "CartItem", into: appDelegate.managedObjectContext!) as! CartItem
                cartItem.productId = productId
                cartItem.quantity = 1
                cartItem.userId = userId
                
                cartItem.cart = cart
                appDelegate.saveContext()
            }
        }
    }
    
    class func removeFromCart(userId : Int16, productId : Int16) {
        
        let appDelegate:AppDelegate = {
            return UIApplication.shared.delegate as! AppDelegate
        }()
                
        let cartItem = CoredataManager.getCartItem(userId: userId, productId: productId)
        appDelegate.managedObjectContext?.delete(cartItem!)
        appDelegate.saveContext()
        
    }
    
    class func incrementQuantity(userId : Int16, productId : Int16) {
        let appDelegate:AppDelegate = {
            return UIApplication.shared.delegate as! AppDelegate
        }()
                
        if let cartItem = CoredataManager.getCartItem(userId: userId, productId: productId) {
            let qty = cartItem.quantity + 1
            cartItem.quantity = qty
            appDelegate.saveContext()
        }
    }
    
    class func decrementQuantity(userId : Int16, productId : Int16) {
        let appDelegate:AppDelegate = {
            return UIApplication.shared.delegate as! AppDelegate
        }()
                
        if let cartItem = CoredataManager.getCartItem(userId: userId, productId: productId) {
            let qty = cartItem.quantity - 1
            
            if qty >= 0 {
                cartItem.quantity = qty
                appDelegate.saveContext()
            }
        }
    }
    
    class func getCartItem(userId : Int16, productId : Int16) -> CartItem? {
        if let fetchResults = self.fetchEntity(entity: "CartItem", andPredicate: NSPredicate(format: "userId == \(userId) && productId == \(productId)"))
        {
            return fetchResults.first as? CartItem
        }
        else {
            return nil
        }
    }
    
    class func getCartItems(userId : Int16) -> [CartItem] {
        if let fetchResults = self.fetchEntity(entity: "CartItem", andPredicate: NSPredicate(format: "userId == \(userId)"))
        {
            return (fetchResults as? [CartItem])!
        }
        else {
            return []
        }
    }
    
    class func getCartForUser(userid : Int16) -> Cart? {
        
        
        if let fetchResults = self.fetchEntity(entity: "Cart", andPredicate: NSPredicate(format: "userId == \(userid)"))
        {
            return fetchResults.first as? Cart
        }
        else {
            return nil
        }
    }
    
    class func getproduct(id : Int16) -> Product? {
        
        if let fetchResults = self.fetchEntity(entity: "Product", andPredicate: NSPredicate(format: "id == \(id)"))
        {
            return fetchResults.first as? Product
        }
        else {
            return nil
        }
    }
}
