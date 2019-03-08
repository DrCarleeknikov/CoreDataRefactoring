//
//  Table.swift
//  BookModel
//
//  Created by Joshua Bryson on 2/28/19.
//  Copyright © 2019 Carleek Codes LLC. All rights reserved.
//

import CoreData

final class Table: NSManagedObject, ManagedDecodable, RelatedSequencedManagedObject {
    var relatedObjectKey = "book"
    
    enum CodingKeys:CodingKey{
        case title, number, notes, isPlain, columns, materials
    }
    
    @NSManaged fileprivate(set) var title:String
    @NSManaged fileprivate(set) var number:String
    @NSManaged fileprivate(set) var notes:String?
    @NSManaged fileprivate(set) var isPlain:Bool
    @NSManaged fileprivate(set) var sequence:Int16
    @NSManaged fileprivate(set) var book:Book
    @NSManaged fileprivate(set) var properties:Set<Property>
    @NSManaged fileprivate(set) var materials:Set<Material>

    required convenience init(from decoder: Decoder) throws {
        
        let (context, container) = try Book.retrieveContextAndContainer(from: decoder, keyedBy:CodingKeys.self)
        
        guard let title = try? container.decode(String.self, forKey: .title) else {throw CodableError.keyNotFound("title")}
        guard let number  = try? container.decode(String.self, forKey: .number) else {throw CodableError.keyNotFound("number")}
        guard let isPlain = try? container.decode(Bool.self, forKey: .isPlain) else {throw CodableError.keyNotFound("isPlain")}
        guard let properties = try? container.decode([Property].self, forKey: .columns) else { throw CodableError.keyNotFound("columns") }
        guard let materials = try? container.decode([Material].self, forKey: .materials) else {throw CodableError.keyNotFound("materials")}
        
        let notes = try? container.decode(String.self, forKey: .notes)
        
        self.init(in: context)

        self.title = title
        self.number = number
        self.notes = notes
        self.isPlain = isPlain
        
        set(relatedObject: self, for: properties)
        set(relatedObject: self, for: materials)
        
    }
}

extension Table:Managed{
    static var entityName: String {return "Table"}
    
    static func insert(into context:NSManagedObjectContext, title:String, number:String, notes:String?, isPlain:Bool, sequence:Int16, book:Book)->Table{
        
        let newTable:Table = context.insertObject()
        newTable.title = title
        newTable.number = number
        newTable.notes = notes
        newTable.isPlain = isPlain
        newTable.sequence = sequence
        newTable.book = book
        
        return newTable
    }
    
    func setColumns(columns:Set<Property>){
        self.properties = columns
    }
    
    func setMaterials(materials:Set<Material>){
        self.materials = materials
    }
}

extension Table{
    var sortedColums:[Property]{
        return properties.sorted{return $0.sequence <= $1.sequence}
    }
    
    var sortedMaterials:[Material]{
        return materials.sorted{return $0.sequence <= $1.sequence}
    }
}
