//
//  ManagedDecodable.swift
//  BookModel
//
//  Created by Joshua Bryson on 3/6/19.
//  Copyright © 2019 Carleek Codes LLC. All rights reserved.
//

import Foundation
import CoreData


protocol SequencedManagedObject {
    var sequence:Int16{get}
    func set(_ sequence:Int16)
}

extension SequencedManagedObject where Self:NSManagedObject{
    func set(_ sequence:Int16){
        self.setValue(sequence, forKey: "sequence")
    }
}

protocol RelatedManagedObject {
    var relatedObjectKey:String{get}
    func set(_ relatedObject:NSManagedObject)
}

extension RelatedManagedObject where Self:NSManagedObject{
    func set(_ relatedObject:NSManagedObject){
        self.setValue(relatedObject, forKey: relatedObjectKey)
    }
}

protocol RelatedSequencedManagedObject:RelatedManagedObject, SequencedManagedObject{
    func set(relatedObject:NSManagedObject, with sequence:Int16)
}

extension RelatedSequencedManagedObject {
    func set(relatedObject:NSManagedObject, with sequence:Int16){
        self.set(sequence)
        self.set(relatedObject)
    }
}

protocol ManagedDecodable:Decodable{

    init(in context:NSManagedObjectContext)
    static func retrieveContextAndContainer<Key>(from decoder:Decoder, keyedBy type:Key.Type)throws->(NSManagedObjectContext, KeyedDecodingContainer<Key>) where Key:CodingKey
    func set(relatedObject:NSManagedObject,for objects:[RelatedSequencedManagedObject])

    
}

extension ManagedDecodable where Self:Managed, Self:NSManagedObject{
    
    init(in context:NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: Self.entityName, in: context)!
        self.init(entity: entity, insertInto: context)
    }
    
    static func retrieveContextAndContainer<Key>(from decoder:Decoder, keyedBy type:Key.Type)throws->(NSManagedObjectContext, KeyedDecodingContainer<Key>) where Key:CodingKey{
        guard let context = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext else {throw CodableError.contextNotFound}
        
        guard let container = try? decoder.container(keyedBy: type) else {throw CodableError.contextNotFound}
        
        return (context, container)
    }
    
    func set(relatedObject:NSManagedObject,for objects:[RelatedSequencedManagedObject]){
        for (index, object) in objects.enumerated(){
            object.set(relatedObject: relatedObject, with: Int16(index))
        }
    }
    
}


