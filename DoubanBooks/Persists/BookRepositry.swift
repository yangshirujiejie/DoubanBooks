//
//  BookRepositry.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class BookRepository{
    var app: AppDelegate
    var context: NSManagedObjectContext
    //insert,get,getBykeyword,deletp,update
    
    init(_ app: AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    
    //插入一笔新的数据
    func insert(vm: VMBook) throws {
        let description = NSEntityDescription.entity(forEntityName: VMBook.entityName, in: context)
        let book = NSManagedObject(entity: description!, insertInto: context)
        
        book.setValue(vm.id,forKey: VMBook.colId)
        book.setValue(vm.categoryId,forKey: VMBook.colCategoryId)
        book.setValue(vm.image,forKey: VMBook.colImage)
        book.setValue(vm.author,forKey: VMBook.colAuthor)
        book.setValue(vm.aothor_intro,forKey: VMBook.colAothor_intro)
        book.setValue(vm.binding,forKey: VMBook.colBinding)
        book.setValue(vm.isbn10,forKey: VMBook.colIsbn10)
        book.setValue(vm.isbn13,forKey: VMBook.colIsbn13)
        book.setValue(vm.pages,forKey: VMBook.colPages)
        book.setValue(vm.price,forKey: VMBook.colPrice)
        book.setValue(vm.pubdate,forKey: VMBook.colPubdate)
        book.setValue(vm.publisher,forKey: VMBook.colPublisher)
        book.setValue(vm.summary,forKey: VMBook.colSummary)
        book.setValue(vm.title,forKey: VMBook.colTitle)
        app.saveContext()
    }
    
    func isExists(isbn: String) throws -> Bool {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "\(VMBook.colIsbn10) = %@ || \(VMBook.colIsbn13)", isbn,isbn)
        do {
            let result = try context.fetch(fetch) as! [VMBook]
            return result.count > 0
        } catch {
            throw DateError.entityExistsError("判断存在数据失败")
        }
    }
    //搜索
    func getBook(keyword:String? = nil) throws -> [VMBook] {
        var book = [VMBook]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        do{
            let result = try context.fetch(fetch) as! [VMBook]
            for c in result {
                let vm = VMBook()
                vm.id = c.id
                vm.categoryId = c.categoryId
                vm.image = c.image
                vm.author = c.author
                vm.aothor_intro = c.aothor_intro
                vm.binding = c.binding
                vm.isbn10 = c.isbn10
                vm.isbn13 = c.isbn13
                vm.pages = c.pages
                vm.price = c.price
                vm.pubdate = c.pubdate
                vm.publisher = c.publisher
                vm.summary = c.summary
                vm.title = c.title
                book.append(vm)
            }
        }catch{
            throw DateError.readCollectionError("读取集合数据失败")
        }
        return book
    }
    
    
    //查找
    func getBy(keyword format:String,args:[Any]) throws -> [VMBook] {
        var books = [VMBook]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do{
            let result = try context.fetch(fetch) as! [VMBook]
            for c in result {
                let vm = VMBook()
                vm.id = c.id
                vm.categoryId = c.categoryId
                vm.image = c.image
                vm.author = c.author
                vm.aothor_intro = c.aothor_intro
                vm.binding = c.binding
                vm.isbn10 = c.isbn10
                vm.isbn13 = c.isbn13
                vm.pages = c.pages
                vm.price = c.price
                vm.pubdate = c.pubdate
                vm.publisher = c.publisher
                vm.summary = c.summary
                vm.title = c.title
                
                books.append(vm)
            }
        }catch{
            throw DateError.readCollectionError("读取集合数据失败")
        }
        return books
    }
    
    
    //更新
    func update(vm: VMBook) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", vm.id.uuidString)
        do{
            let obj = try context.fetch(fetch)[0] as! NSManagedObject
            
            obj.setValue(vm.author, forKey: VMBook.colAuthor)
            obj.setValue(vm.aothor_intro, forKey: VMBook.colAothor_intro)
            obj.setValue(vm.binding, forKey: VMBook.colBinding)
            obj.setValue(vm.image, forKey: VMBook.colImage)
            obj.setValue(vm.isbn10, forKey: VMBook.colIsbn10)
            obj.setValue(vm.isbn13, forKey: VMBook.colIsbn13)
            obj.setValue(vm.pages, forKey: VMBook.colPages)
            obj.setValue(vm.price, forKey: VMBook.colPrice)
            obj.setValue(vm.pubdate, forKey: VMBook.colPubdate)
            obj.setValue(vm.publisher, forKey: VMBook.colPublisher)
            obj.setValue(vm.summary, forKey: VMBook.colSummary)
            obj.setValue(vm.title, forKey: VMBook.colTitle)
            
            app.saveContext()
        }catch{
            throw DateError.updateEntityError("更新图书失败")
        }
    }
    
    //删除
    func delete(id: UUID)throws{
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do {
            let result = try context.fetch(fetch)
            for b in result{
                context.delete(b as! NSManagedObject)
            }
            app.saveContext()
        } catch  {
            throw DateError.deleteEntityError("图书删除失败")
        }
    }
    
}

