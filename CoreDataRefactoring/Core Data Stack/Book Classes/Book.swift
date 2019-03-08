//
//  Book.swift
//  BookModel
//
//  Created by Joshua Bryson on 2/28/19.
//  Copyright © 2019 Carleek Codes LLC. All rights reserved.
//

import Foundation
import CoreData

final class Book: NSManagedObject, ManagedDecodable {
   
    enum CodingKeys:CodingKey{
        case title, edition, authors, coverURL, version, chapters, tables
    }
    
    @NSManaged fileprivate(set) var title:String
    @NSManaged fileprivate(set) var edition:String
    @NSManaged fileprivate(set) var authors:String
    @NSManaged fileprivate(set) var coverURL:String?
    @NSManaged fileprivate(set) var lastOpened:Date
    @NSManaged fileprivate(set) var version:Int16
    
    @NSManaged fileprivate(set) var chapters:Set<Chapter>
    @NSManaged fileprivate(set) var tables:Set<Table>
    
    required convenience init(from decoder: Decoder) throws {
        
        let (context, container) = try Book.retrieveContextAndContainer(from: decoder, keyedBy:CodingKeys.self)

        guard let title = try? container.decode(String.self, forKey: .title) else {throw CodableError.keyNotFound("title")}
        guard let edition = try? container.decode(String.self, forKey: .edition) else {throw CodableError.keyNotFound("edition")}
        guard let authors = try? container.decode(String.self, forKey: .authors) else {throw CodableError.keyNotFound("authors")}
        guard let version = try? container.decode(Int.self, forKey: .version) else {throw CodableError.keyNotFound("version")}
        
        guard let chapters = try? container.decode([Chapter].self, forKey: .chapters) else {throw CodableError.keyNotFound("chapters")}
        
        let tables = try? container.decode([Table].self, forKey: .tables)
        let coverURL = try? container.decode(String.self, forKey: .coverURL)
        
        self.init(in: context)

        self.title = title
        self.edition = edition
        self.authors = authors
        self.version = Int16(version)
        self.coverURL = coverURL
        
        set(relatedObject: self, for: chapters)
        self.chapters = Set(chapters)
        
        if let unwrappedTables = tables{
            set(relatedObject: self, for: unwrappedTables)
            self.tables = Set(unwrappedTables)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    var sortedChaptes:[Chapter]{
        return chapters.sorted{$0.sequence <= $1.sequence}
    }
    
    var sortedTables:[Table]{
        return tables.sorted{$0.sequence <= $1.sequence}
    }
    
    func wasOpened(in context:NSManagedObjectContext){
        lastOpened = Date()
        try! context.save()
    }

}

extension Book:Managed{
    
    static var entityName: String {return "Book"}
    
    static func insert(into context:NSManagedObjectContext, title:String, edition:String, authors:String, coverURL:String?, version:Int)->Book{
        
        let newBook:Book = context.insertObject()
        
        newBook.title = title
        newBook.edition = edition
        newBook.authors = authors
        newBook.coverURL = coverURL
        newBook.version = Int16(version)
        newBook.lastOpened = Date()
        
        return newBook
    }
    
    func setChapters(chapters:Set<Chapter>){
        self.chapters = chapters
    }
    
    func setTables(tables:Set<Table>){
        self.tables = tables
    }
}

extension Book{
    class func importBookAt(url:URL, into context:NSManagedObjectContext) throws{
        guard let data = try? Data(contentsOf: url) else {throw ImportError.noDataAtURL}
        let decoder = PropertyListDecoder()
         decoder.userInfo[CodingUserInfoKey.context] = context
        _ = try decoder.decode(Book.self, from: data)
        try context.save()
    }
}
enum ImportError:Error{
    case noDataAtURL
}

enum CodableError:Error{
    case containerNotFound
    case contextNotFound
    case keyNotFound(String)
    
}

extension CodingUserInfoKey{
    static let context = CodingUserInfoKey(rawValue: "context")!
}
