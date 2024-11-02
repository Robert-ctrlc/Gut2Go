//
//  User+CoreDataProperties.swift
//  Gut2GoLocal
//
//  Created by Robert Manolache on 02/11/2024.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?

}

extension User : Identifiable {

}
