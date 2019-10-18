//
//  CategoryFactory.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import Foundation
import CoreData
final class Foundation {
    var app:AppDelegate?
    // var repository: CategoryRepository
    //static let instance = CategoryRepository(app: AppDelegate)
    static var instance: Foundation?
    
    var repository: Repository<VMCategory>
    private init(_ app: AppDelegate) {
        repository = Repository<VMCategory>(app)
        self.app = app
    }
    
    //同步处理代码
    static func getInstance(_ app: AppDelegate)-> Foundation{
        if let obj = instance {
            return obj
        }else{
            let token = "net.lzzy.factory.category"
            DispatchQueue.once(token: token, block: {
                if instance == nil {
                    instance = Foundation(app)
                }
            })
            return instance!
        }
    }
    
    //查询所有
    func  getAllCategories() throws ->[VMCategory]{
        return try repository.get()
    }
    
    //查询单个
    func getName(keyword:String) throws ->[VMCategory] {
        return try repository.get(keyword: keyword)
    }
    
    //模糊查询   var name:String?    var image:String?
    func getby(keyword: String) throws -> [VMCategory]{
        return try repository.getBy([VMCategory.colName], keyword: keyword)
    }
    
    func getBooksCountOfCategory(category id:UUID) -> Int? {
        do {
            return try
                BookFactory.getInstance(app!).getBooksOf(category: id).count
        } catch  {
            return nil
        }
    }
    
    //修改
    func update(category: VMCategory) throws {
        try  repository.update(vm: category)
    }
    
    // 删除
    func remove(category: VMCategory) -> (Bool,String?) {
        if let count = getBooksCountOfCategory(category: category.id){
            if count > 0 {
                return (false,"存在该类别图书，不能删除")
            }
        }else{
            return (false,"无法获取类别信息")
        }
        do{
            try repository.delete(id: category.id)
            return (true,nil)
        }catch DateError.deleteEntityError(let info){
            return (false,info)
        }catch{
            return (false,error.localizedDescription)
        }
    }
    
    //新增
    func addCategory(category: VMCategory) throws -> (Bool, String?) {
        do{
            if try repository.isEntityExists([VMCategory.colName],keyword: category.name!){
                return (false,"同样的类别已经存在")
            }
            try repository.insert(vm: category)
            return(true,nil)
            
        }catch DateError.entityExistsError(let info){
            return (false,info)
        }catch{
            return (false, error.localizedDescription)
        }
    }
    
    
}
//线程管理扩展
extension DispatchQueue {
    private static var _onceTracker = [String]()
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
