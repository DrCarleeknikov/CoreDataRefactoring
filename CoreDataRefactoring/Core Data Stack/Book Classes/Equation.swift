//
//  Equation.swift
//  BookModel
//
//  Created by Joshua Bryson on 2/28/19.
//  Copyright © 2019 Carleek Codes LLC. All rights reserved.
//

import CoreData

final class Equation: NSManagedObject, Codable {
    
    enum CodingKeys:CodingKey{
        case latex, name, number
    }
    
    @NSManaged fileprivate(set) var latex:String
    @NSManaged fileprivate(set) var name:String
    @NSManaged fileprivate(set) var number:String
    @NSManaged fileprivate(set) var sequence:Int16
    @NSManaged fileprivate(set) var chapter:Chapter
    
    required convenience init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext else {throw CodableError.contextNotFound}
        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else {throw CodableError.contextNotFound}
        
        guard let latex = try? container.decode(String.self, forKey: .latex) else {throw CodableError.keyNotFound("latex")}
        guard let name = try? container.decode(String.self, forKey: .name) else {throw CodableError.keyNotFound("name")}
        guard let number = try? container.decode(String.self, forKey: .number) else {throw CodableError.keyNotFound("number")}
        
        let entity = NSEntityDescription.entity(forEntityName: Equation.entityName, in: context)!
        self.init(entity: entity, insertInto: context)
        
        self.latex = latex
        self.number = number
        self.name = name
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    func setChapter(chapter:Chapter){
        self.chapter = chapter
    }
    
    func setSequence(sequence:Int16){
        self.sequence = sequence
    }
}

extension Equation:Managed{
    static var entityName: String {return "Equation"}
    
    static func insert(into context:NSManagedObjectContext, name:String, number:String, latex:String, sequence:Int16,  chapter:Chapter)->Equation{
        
        let newEquation:Equation = context.insertObject()
        newEquation.name = name
        newEquation.number = number
        newEquation.latex = latex
        newEquation.sequence = sequence
        newEquation.chapter = chapter
        
        return newEquation
    }
}


