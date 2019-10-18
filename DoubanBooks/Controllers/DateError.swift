//
//  DateError.swift
//  DoubanBooks
//
//  Created by 2017yid on 2019/10/18.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation

enum DateError:Error{
    case readCollectionError(String)
    case readSingleError(String)
    case entityExistsError(String)
    case deleteEntityError(String)
    case updateEntityError(String)
}
