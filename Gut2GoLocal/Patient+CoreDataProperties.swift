//
//  Patient+CoreDataProperties.swift
//  Gut2GoLocal
//
//  Created by Robert Manolache on 02/11/2024.
//
//

import Foundation
import CoreData


extension Patient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Patient> {
        return NSFetchRequest<Patient>(entityName: "Patient")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16

}

extension Patient : Identifiable {

}
