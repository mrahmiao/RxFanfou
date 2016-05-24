//
//  UserManager+Rx.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 5/24/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import RxSwift

extension UserManager {


  /**
   获取指定用户正在关注的用户

   - parameter userID:     用户ID，`@~me`表示当前登录用户
   - parameter count:      返回结果的数量
   - parameter page:       返回结果的页码，取值范围1-60
   - parameter reformer:   从原始JSON到业务方模型的转换方法

   - returns: Observable
   */
  public func fetchFollowers<T>(userID: String = "@~me", count: Int, page: Int, reformer: [[String: AnyObject]] -> T?) -> Observable<T> {
    return createObservable { [weak self] observer in
      return self?.fetchFollowers(userID, count: count, page: page, reformer: reformer, completion: onCompletion(observer))
    }

  }

  /**
   获取指定用户正在关注的用户

   - parameter userID:     用户ID，`@~me`表示当前登录用户
   - parameter count:      返回结果的数量
   - parameter page:       返回结果的页码，取值范围1-60
   - parameter reformer:   从原始JSON到业务方模型的转换方法

   - returns: Observable
   */
  public func fetchFollowings<T>(userID: String = "@~me", count: Int, page: Int, reformer: [[String: AnyObject]] -> T?) -> Observable<T> {
    return createObservable { [weak self] observer in
      return self?.fetchFollowings(userID, count: count, page: page, reformer: reformer, completion: onCompletion(observer))
    }
  }

  /**
   获取指定用户的信息

   - parameter userID:     用户ID
   - parameter reformer:   从原始JSON到业务方模型的转换方法

   - returns: Observable
   */
  public func fetchUser<T>(userID: String = "@~me", reformer: [String: AnyObject] -> T?) -> Observable<T> {
    return createObservable { [weak self] observer in
      return self?.fetchUser(userID, reformer: reformer, completion: onCompletion(observer))
    }
  }
}