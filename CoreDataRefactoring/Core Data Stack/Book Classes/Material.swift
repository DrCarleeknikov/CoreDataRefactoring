//
//  Material.swift
//  BookModel
//
//  Created by Joshua Bryson on 2/28/19.
//  Copyright © 2019 Carleek Codes LLC. All rights reserved.
//

import CoreData

final class Material: NSManagedObject, ManagedDecodable, RelatedSequencedManagedObject {

    var relatedObjectKey = "table"

    enum CodingKeys:CodingKey{
        case name, notes, rawData
    }
    @NSManaged fileprivate(set) var name:String
    @NSManaged fileprivate(set) var notes:String?
    @NSManaged fileprivate(set) var rawData:String
    @NSManaged fileprivate(set) var sequence:Int16
    @NSManaged fileprivate(set) var table:Table
    

    
    required convenience init(from decoder: Decoder) throws {
        
        let (context, container) = try Book.retrieveContextAndContainer(from: decoder, keyedBy:CodingKeys.self)
        
        guard let name = try? container.decode(String.self, forKey: .name) else {throw CodableError.keyNotFound("name")}
        guard let rawData = try? container.decode(String.self, forKey: .rawData) else {throw CodableError.keyNotFound("rawData")}
        
        let notes = try? container.decode(String.self, forKey: .notes)
        
        self.init(in: context)
        
        self.name = name
        self.rawData = rawData
        self.notes = notes
    }
    
}

extension Material:Managed{
    static var entityName: String {return "Material"}
    
    static func insert(into context:NSManagedObjectContext, name:String, notes:String?, rawData:String,  table:Table)->Material{
        
        let newMaterial:Material = context.insertObject()
        newMaterial.name = name
        newMaterial.notes = notes
        newMaterial.rawData = rawData
        newMaterial.table = table
        
        return newMaterial
    }
}

extension Material{
    
}
