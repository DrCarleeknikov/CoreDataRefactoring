//
//  NSManagedObjectContextExtension.swift
//  BookModel
//
//  Created by Joshua Bryson on 3/7/18.
//  Copyright © 2018 Carleek Codes LLC. All rights reserved.
//

import CoreData

public extension NSManagedObjectContext {
    
    internal func insertObject<A:NSManagedObject>()->A where A:Managed{
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else {
            fatalError("Wrong object type")
        }
        return obj
    }
    
    public func saveOrRollback()->Bool{
        do{
            try save()
            return true
        } catch{
            rollback()
            return false
        }
    }
    
    public func performChanges(block:@escaping ()->()){
        perform {
            block()
            _ = self.saveOrRollback()
        }
    }
}


