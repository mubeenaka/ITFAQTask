//
//  Cart.swift
//  ItfaqTask
//
//  Created by Mubeena Thahir on 4/7/21.
//

import UIKit
import CoreData

class Cart: NSManagedObject {

    @NSManaged var id: Int16
    @NSManaged var userId: Int16
    @NSManaged var cartItems: NSSet
}
