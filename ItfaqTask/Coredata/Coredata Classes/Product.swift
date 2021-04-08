//
//  Product.swift
//  ItfaqTask
//
//  Created by Mubeena Thahir on 4/7/21.
//

import UIKit
import CoreData

class Product: NSManagedObject {

    @NSManaged var id: Int16
    @NSManaged var title: String
    @NSManaged var desc: String
    @NSManaged var price: Float
    @NSManaged var image: String
    @NSManaged var category: String
}
