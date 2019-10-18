//
//  Repository.swift
//  DoubanBooks
//
//  Created by 2017yid on 2019/10/18.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation
import CoreData
class Repository<T: DataViewModelDelegate> where T:NSObject{
    
    var app: AppDelegate
    var context: NSManagedObjectContext
    //insert,get,getBykeyword,deletp,update
    
    init(_ app: AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    
    func get(keyword:String? = nil) throws -> [T] {
        var obj = [T]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        do{
            let result = try context.fetch(fetch)
            for c in result {
                let t = T()
                t.packageSelf(result: c as! NSFetchRequestResult)
                obj.append(t)
            }
            return obj
        }catch{
            throw DateError.readCollectionError("读取集合数据失败")
        }
    }
    
    /// 根据关键字词查询某一实体类符合条件的数据，模糊查询
    ///
    /// - parameter cols: 需要匹配的列如：["name","publisher"]
    /// - parameter keyword: 要搜索的关键词
    /// - returns：视图模型对象集合
    func getBy(_ cols: [String],keyword: String) throws -> [T] {
        var items = [T]()
        var format = ""
        var args = [String]()
        for col in cols {
            format += "\(col)  lick[c] %@ || "
            args.append("*\(keyword)*")
        }
        format.removeLast(3)
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do{
            let result = try context.fetch(fetch)
            for c in result {
                let t = T()
                t.packageSelf(result: c as! NSFetchRequestResult)
                items.append(t)
            }
        }catch{
            throw DateError.readCollectionError("读取集合数据失败")
        }
        return items
    }
    
    //更新
    func update(vm: T) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", vm.id.uuidString)
        do{
            let obj = try context.fetch(fetch)[0] as! NSManagedObject
            for (key,value) in vm.entityPairs() {
                obj.setValue(value, forKey: key)
            }
            app.saveContext()
        }catch{
            throw DateError.updateEntityError("数据更新失败")
        }
    }
    //删除
    func delete(id: UUID)throws{
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
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
    
    //插入一笔新的数据
    func insert(vm: T) throws {
        let description = NSEntityDescription.entity(forEntityName: T.entityName, in: context)
        let obj = NSManagedObject(entity: description!, insertInto: context)
        for (key,value) in vm.entityPairs() {
            obj.setValue(value, forKey: key)
        }
        app.saveContext()
    }
    
    func isEntityExists(_ cols : [String], keyword: String) throws -> Bool {
        var format = ""
        var args = [String]()
        for col in cols {
            format += "\(col) = %@ || "
            args.append(keyword)
        }
        format.removeLast(3)
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate (format: format, argumentArray: args)
        do {
            let result = try context.fetch(fetch)
            return result.count > 0
        } catch  {
            throw DateError.entityExistsError("判断数据存在失败")
        }
    }
    
}
