//
//  Restorable.swift
//  BookModel
//
//  Created by Joshua Bryson on 12/19/18.
//  Copyright © 2018 Carleek Codes LLC. All rights reserved.
//

import Foundation
import CoreData

protocol Restorable {
    var restorationIdentifier:String {get}
}


extension Restorable where Self: NSManagedObject {

    var restorationIdentifier:String {
        return self.objectID.uriRepresentation().absoluteString
    }
}

extension NSManagedObject: Restorable{
    var restorationIdentifier:String {
        return self.objectID.uriRepresentation().absoluteString
    }
}
