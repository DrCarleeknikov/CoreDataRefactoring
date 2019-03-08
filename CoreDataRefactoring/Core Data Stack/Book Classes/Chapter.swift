//
//  Chapter.swift
//  BookModel
//
//  Created by Joshua Bryson on 2/28/19.
//  Copyright © 2019 Carleek Codes LLC. All rights reserved.
//

import CoreData

final class Chapter: NSManagedObject, ManagedDecodable, RelatedSequencedManagedObject{
    
    var relatedObjectKey = "book"
    
    enum CodingKeys:CodingKey{
        case title, number, equations
    }
    
    @NSManaged fileprivate(set) var title:String
    @NSManaged fileprivate(set) var number:String
    @NSManaged fileprivate(set) var sequence:Int16
    @NSManaged fileprivate(set) var book:Book
    @NSManaged fileprivate(set) var equations:Set<Equation>

    required convenience init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext else {throw CodableError.contextNotFound}
        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else {throw CodableError.contextNotFound}
        
        guard let title = try? container.decode(String.self, forKey: .title) else {throw CodableError.keyNotFound("title")}
        guard let number  = try? container.decode(String.self, forKey: .number) else {throw CodableError.keyNotFound("number")}
        guard let equations = try? container.decode([Equation].self, forKey: .equations) else {throw CodableError.keyNotFound("equations")}
        
        
        let entity = NSEntityDescription.entity(forEntityName: Chapter.entityName, in: context)!
        self.init(entity: entity, insertInto: context)
        
        self.title = title
        self.number = number
        
        for (index, equation) in equations.enumerated(){
            equation.setChapter(chapter: self)
            equation.setSequence(sequence:Int16(index))
        }
        
        self.equations = Set(equations)
    }

    var sortedEquations:[Equation]{
        return equations.sorted{$0.sequence <= $1.sequence}
    }
}


extension Chapter:Managed{
    static var entityName: String {return "Chapter"}
    
    static func insert(into context:NSManagedObjectContext, title:String, number:String, sequence:Int16, book:Book)->Chapter{
        
        let newEquation:Chapter = context.insertObject()
        newEquation.title = title
        newEquation.number = number
        newEquation.sequence = sequence
        newEquation.book = book
        
        return newEquation
    }
    
    func setEquations(equations:Set<Equation>){
        self.equations = equations
    }
}
