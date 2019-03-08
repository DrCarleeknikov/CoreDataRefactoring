//
//  CoreDataContainer.swift
//  BookModel
//
//  Created by Joshua Bryson on 12/14/18.
//  Copyright © 2018 Carleek Codes LLC. All rights reserved.
//

import Foundation
import CoreData

typealias ContextAccesser = (NSManagedObjectContext)->()
class CoreDataContainer:NSObject{
    
    fileprivate var hasLoadedStore = false{
        didSet{
            if hasLoadedStore{
                for consumer in waitingAccessers {
                    consumer(persistentContainer.viewContext)
                }
                waitingAccessers.removeAll()
            }
        }
    }
    var persistentContainer:NSPersistentContainer = NSPersistentContainer(name: "BookModel")
    fileprivate var waitingAccessers = [ContextAccesser]()
    
    override init() {
        super.init()
        loadContainer()
    }
    
    func loadContainer(){
        persistentContainer.loadPersistentStores { _, error in
            guard error == nil else { fatalError("Failed to load store: \(error!)") }

            //            container.viewContext.undoManager = self.window?.undoManager
            DispatchQueue.main.async { self.hasLoadedStore = true }
        }
    }

    func accessManagedContext(accesser:@escaping ContextAccesser){
        if hasLoadedStore {
            accesser(persistentContainer.viewContext)
        } else {
            waitingAccessers.append(accesser)
        }
        
    }
    
        
}
