//
//  BookFactory.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/15.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import Foundation
import CoreData
final class BookFactory {
    var app:AppDelegate?
    var repository: Repository<VMBook>
    static var instance: BookFactory?
    
    private init(_ app: AppDelegate) {
        repository = Repository<VMBook>(app)
        self.app = app
    }
    
    //同步处理代码
    static func getInstance(_ app: AppDelegate)-> BookFactory{
        if let obj = instance {
            return obj
        }else{
            let token = "net.lzzy.factory.category"
            DispatchQueue.once(token: token, block: {
                if instance == nil {
                    instance = BookFactory(app)
                }
            })
            return instance!
        }
    }
    //查询所有
    func  getAllBook() throws ->[VMBook]{
        return try repository.get()
        
    }
    //根据类别查询
    func getBooksOf(category id: UUID) throws -> [VMBook] {
        return try repository.getBy([VMBook.colCategoryId], keyword: id.uuidString)
    }
    //模糊查询
    func getby(keyword: String) throws -> [VMBook]{
        let cols = [VMBook.colTitle,VMBook.colIsbn13,VMBook.colAuthor,VMBook.colPublisher,VMBook.colSummary]
        let  books =  try repository.getBy(cols, keyword: keyword)
        return books
    }
    
    //根据ID来查询
    func getBookBy(id: UUID) throws -> VMBook? {
        let books = try
            repository.getBy([VMBook.colId], keyword: id.uuidString)
        if books.count > 0 {
            return books[0]
        }
        return nil
    }
    //判断书存在与否
    func isBookExists(book: VMBook) throws -> Bool {
        var match10 = false
        var match13 = false
        if let isbn10 = book.isbn10 {
            if isbn10.count > 0 {
                match10 = try
                    repository.isEntityExists([VMBook.colIsbn10], keyword: isbn10)
            }
        }
        if let isbn13 = book.isbn13 {
            if isbn13.count > 0 {
                match13 = try
                    repository.isEntityExists([VMBook.colIsbn13], keyword: isbn13)
            }
        }
        return match13 || match10
    }
    
    //新增数据
    func addBook(book: VMBook) throws -> (Bool, String?) {
        do{
            if try repository.isEntityExists([VMBook.colIsbn10],keyword: book.isbn10!){
                return (false,"同样的类别已经存在")
            }
            try repository.insert(vm: book)
            return(true,nil)
            
    }catch DateError.entityExistsError(let info){
            return (false,info)
        }catch{
            return (false, error.localizedDescription)
        }
    }
    
    //修改
    func update(category: VMBook) throws {
        try  repository.update(vm: category)
    }
    
    // 删除
    func remove(category: VMBook) -> (Bool,String?) {
        do{
            try repository.delete(id: category.id)
            return (true,nil)
    }catch DateError.deleteEntityError(let info){
            return (false,info)
        }catch{
            return (false,error.localizedDescription)
        }
    }
    
    
    
}
