//
//  VMBook.swift
//  DoubanBooks
//
//  Created by 2017yid on 2019/10/18.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation
import CoreData
class VMBook: NSObject,DataViewModelDelegate{
    
    var aothor_intro: String?
    var author: String?
    var categoryId: UUID?
    var id: UUID
    var image: String?
    var isbn10: String?
    var isbn13: String?
    var pages: Int32?
    var price: Float?
    var pubdate: String?
    var publisher: String?
    var summary: String?
    var title: String?
    var binding: String?
    
    override init() {
        self.id = UUID()
    }
    
    static let entityName = "Book"
    
    static let colAothor_intro = "aothor_intro"
    static let colAuthor = "author"
    static let colCategoryId = "categoryId"
    static let colId = "id"
    static let colImage = "image"
    static let colIsbn10 = "isbn10"
    static let colIsbn13 = "isbn13"
    static let colPages = "pages"
    static let colPrice = "price"
    static let colPubdate = "pubdate"
    static let colPublisher = "publisher"
    static let colSummary = "summary"
    static let colTitle = "title"
    static let colBinding = "binding"
    
    func entityPairs() -> Dictionary<String, Any?> {
        var dic: Dictionary<String,Any?> = Dictionary<String,Any?>()
        dic[VMBook.colAothor_intro] = aothor_intro
        dic[VMBook.colAuthor] = author
        dic[VMBook.colCategoryId] = categoryId
        dic[VMBook.colId] = id
        dic[VMBook.colImage] = image
        dic[VMBook.colIsbn10] = isbn10
        dic[VMBook.colIsbn13] = isbn13
        dic[VMBook.colPages] = pages
        dic[VMBook.colPrice] = price
        dic[VMBook.colPubdate] = pubdate
        dic[VMBook.colSummary] = summary
        dic[VMBook.colTitle] = title
        dic[VMBook.colBinding] = binding
        return dic
        
    }
    
    func packageSelf(result: NSFetchRequestResult) {
        let book = result as! Book
        
        id = book.id!
        categoryId = book.categoryId
        image = book.image
        author = book.author
        aothor_intro = book.authorintro
        isbn10 = book.isbn10
        isbn13 = book.isbn13
        pages = book.pages
        price = book.price
        pubdate = book.pubdate
        publisher = book.publisher
        summary = book.summary
        title = book.title
        binding = book.binding
    }
    
}
