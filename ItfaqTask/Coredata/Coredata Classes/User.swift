//
//  User.swift
//  ItfaqTask
//
//  Created by Mubeena Thahir on 4/7/21.
//

import UIKit
import CoreData

class User: NSManagedObject {

    @NSManaged var id: Int16
    @NSManaged var username: String
    @NSManaged var password: String
}
