//
//  DataViewModeleDelegate.swift
//  DoubanBooks
//
//  Created by 2017yid on 2019/10/15.
//  Copyright © 2019 2017yd. All rights reserved.
//
import CoreData
import CoreData
/**
 - 约束试图模型类的实现，暴露CoreData Entity 相关属性及组装试图模型对象
 */
protocol DataViewModelDelegate {
    /// 试图模型必须具有id属性
    var id:UUID {get}
    ///试图模型对应的CoreData Entity 的名称
    static var entityName:String {get}
    /// CoredData Entity 属性与对应的视图模型对象的属性集合
    ///
    ///-returns: key 是Coredata entity 的各个属性的名称，any是对应的值
    func entityPairs()-> Dictionary<String,Any?>
    ///根据查询结果组装试图模型对象
    ///
    /// -parameter result ： fetch 法方的查询结果
    func packageSelf(result: NSFetchRequestResult)
}
