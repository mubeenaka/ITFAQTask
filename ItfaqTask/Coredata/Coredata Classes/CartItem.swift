//
//  CartItem.swift
//  ItfaqTask
//
//  Created by Mubeena Thahir on 4/7/21.
//

import UIKit
import CoreData

class CartItem: NSManagedObject {

    @NSManaged var productId: Int16
    @NSManaged var quantity: Int16
    @NSManaged var userId : Int16
    
    @NSManaged var cart : Cart
}
