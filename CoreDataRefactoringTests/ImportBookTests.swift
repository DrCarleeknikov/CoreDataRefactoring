//
//  ImportBookTests.swift
//  StemFoxTests
//
//  Created by Joshua Bryson on 3/6/19.
//  Copyright © 2019 Carleek Codes LLC. All rights reserved.
//

import XCTest
@testable import CoreDataRefactoring
class ImportBookTests: CoreDataTests {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testImportBook() {
        let filename = "Example Book"
        guard let path = Bundle.main.path(forResource: filename, ofType: "plist") else {
            XCTAssert(false, "file not found")
            return
        }
        let url = URL(fileURLWithPath: path)

        try? Book.importBookAt(url: url, into: context)

        let expectedBookTitle = "Fundamentals of Engineering Thermodynamics"
        let predicate = NSPredicate(format: "title==%@", expectedBookTitle)
        guard let book = Book.findOrFetch(in: context, matching: predicate) else {
            XCTAssert(false, "book not added correctly")
            return
        }
        
        XCTAssert(book.title == expectedBookTitle)
        XCTAssert(book.authors == "Michael J. Moran, Howord N. Shapiro, Daisie D. Boettner, Margret B. Baily")
        XCTAssert(book.edition == "8th Edition")
        XCTAssert(book.coverURL == "https://media.wiley.com/product_data/coverImage300/31/11184129/1118412931.jpg")
        XCTAssert(book.chapters.count == 3)
        XCTAssert(book.tables.count == 3)
        
        guard let lastChapter = book.sortedChaptes.last else {return}
        XCTAssert(lastChapter.equations.count == 1)
        XCTAssert(lastChapter.title == "Evaluating Properties")
        XCTAssert(lastChapter.number == "3")
        XCTAssert(lastChapter.sequence == 2)
        XCTAssert(lastChapter.book == book)
        
        
        guard let lastTable = book.sortedTables.last else{return}
        XCTAssert(lastTable.properties.count == 4)
        XCTAssert(lastTable.materials.count == 5)
        XCTAssert(lastTable.title == "Atomic or Molecular Weights and Critical Properties of Selected Elements and Compounds")
        XCTAssert(lastTable.number == "A-1")
        XCTAssert(lastTable.book == book)
    }

    func testImportAllBooks(){
        
    }
    
    func testImportNewVersion(){
        
    }
    

}
