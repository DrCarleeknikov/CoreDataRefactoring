//
//  Column.swift
//  BookModel
//
//  Created by Joshua Bryson on 2/28/19.
//  Copyright © 2019 Carleek Codes LLC. All rights reserved.
//

import CoreData

final class Property: NSManagedObject, ManagedDecodable, RelatedSequencedManagedObject {
    
    var relatedObjectKey = "table"
    
    enum CodingKeys:CodingKey{
        case name, units
    }
    
    @NSManaged fileprivate(set) var name:String
    @NSManaged fileprivate(set) var units:String
    @NSManaged fileprivate(set) var sequence:Int16
    @NSManaged fileprivate(set) var table:Table
    
    required convenience init(from decoder: Decoder) throws {
       
        let (context, container) = try Book.retrieveContextAndContainer(from: decoder, keyedBy:CodingKeys.self)
        
        let name = try? container.decode(String.self, forKey: .name)
        let units = try? container.decode(String.self, forKey: .units)

        self.init(in: context)
        
        self.name = name ?? ""
        self.units = units ?? ""
    }
}

extension Property:Managed{
    static var entityName: String {return "Property"}
    
    static func insert(into context:NSManagedObjectContext, name:String, units:String, sequence:Int16,  table:Table)->Property{
        
        let newColumn:Property = context.insertObject()
        newColumn.name = name
        newColumn.units = units
        newColumn.sequence = sequence
        newColumn.table = table
        
        return newColumn
    }
}
