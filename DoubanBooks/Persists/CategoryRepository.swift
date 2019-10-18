//
//  CategoryRepository.swift
//  DoubanBooks
//
//  Created by 2017yid on 2019/10/16.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation
import CoreData

class CategoryRepository{
    // isExists,insert,get,getByKeyword,delete,update
    var app: AppDelegate
    var context: NSManagedObjectContext
    
    
    
    init(_ app: AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    
    
    func insert(vm : VMCategory) throws {
        //描述实体对象
        let description = NSEntityDescription.entity(forEntityName:VMCategory.entityName, in: context)
        //创建实体对象
        let movie = NSManagedObject(entity: description!, insertInto: context)
        movie.setValue(vm.id, forKey: VMCategory.colId)
        movie.setValue(vm.image, forKey: VMCategory.colImage)
        movie.setValue(vm.name, forKey: VMCategory.colName)
        
        app.saveContext()
    }
    
    func getCategory(keyword:String? = nil)throws-> [VMCategory]{
        var categorys = [VMCategory]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        do {
            if let kw = keyword {
                //   fetch.predicate = NSPredicate(format: "name like[c] %@ || place like[c] %@", "*\(kw)*", "*\(kw)*")
                fetch.predicate = NSPredicate(format: "name like[c] %@ ","*\(kw)*")
            }
            let result = try context.fetch(fetch) as! [Category]
            for itme in result {
                let vm = VMCategory()
                vm.id = itme.id!
                vm.name = itme.name
                vm.image = itme.image
                categorys.append(vm)
            }
        }catch {
            throw   DateError.readCollectionError("读取数据错误！")
        }
        return categorys
    }
    
    func isExists(name: String) throws -> Bool {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: "\(VMCategory.colName) = %@", name)
        do {
            let result = try context.fetch(fetch) as! [VMCategory]
            return result.count > 0
        } catch {
            throw DateError.entityExistsError("判断存在数据失败")
        }
    }
    
    
    func delete(id: UUID)throws{
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        let result = try context.fetch(fetch) as! [Category]
        for m in result {
            context.delete(m)
        }
        app.saveContext()
    }
    
    
    //更新
    func update(vm: VMCategory) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", vm.id.uuidString)
        do{
            let obj = try context.fetch(fetch)[0] as! NSManagedObject
            
            obj.setValue(vm.name, forKey: VMCategory.colName)
            obj.setValue(vm.image, forKey: VMCategory.colImage)
            
            
            app.saveContext()
        }catch{
            throw DateError.updateEntityError("更新图书失败")
        }
    }
    
}
