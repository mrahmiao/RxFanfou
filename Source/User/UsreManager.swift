//
//  UsreManager.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 5/24/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import Moya
import Result

public final class UserManager: APIManagerType {

  var consumerCredential: ConsumerCredential
  var tokenCredential: TokenCredential
  let service: APIService<API.User>

  init(consumerCredential: ConsumerCredential, tokenCredential: TokenCredential) {
    self.consumerCredential = consumerCredential
    self.tokenCredential = tokenCredential
    self.service = APIService(consumerCredential: consumerCredential, tokenCredential: tokenCredential)
  }

  /**
   获取指定用户的关注者

   - parameter userID:     用户ID，`@~me`表示当前登录用户
   - parameter count:      返回结果的数量
   - parameter page:       返回结果的页码，取值范围1-60
   - parameter reformer:   从原始JSON到业务方模型的转换方法
   - parameter completion: 请求完后的回调方法

   - returns: 用于取消正在运行的请求的Token
   */
  public func fetchFollowers<T>(userID: String = "@~me", count: Int, page: Int, reformer: [[String: AnyObject]] -> T?, completion: Result<T, Moya.Error> -> Void) -> Cancellable {
    return service.provider.request(.Followers(userID, count, page), completion: reformJSON(reformer, completion))
  }

  /**
   获取指定用户正在关注的用户

   - parameter userID:     用户ID，`@~me`表示当前登录用户
   - parameter count:      返回结果的数量
   - parameter page:       返回结果的页码，取值范围1-60
   - parameter reformer:   从原始JSON到业务方模型的转换方法
   - parameter completion: 请求完后的回调方法

   - returns: 用于取消正在运行的请求的Token
   */
  public func fetchFollowings<T>(userID: String = "@~me", count: Int, page: Int, reformer: [[String: AnyObject]] -> T?, completion: Result<T, Moya.Error> -> Void) -> Cancellable {
    return service.provider.request(.Followings(userID, count, page), completion: reformJSON(reformer, completion))
  }

  /**
   获取指定用户的信息

   - parameter userID:     用户ID
   - parameter reformer:   从原始JSON到业务方模型的转换方法
   - parameter completion: 请求完后的回调方法

   - returns: 用于取消正在运行的请求的Token
   */
  public func fetchUser<T>(userID: String = "@~me", reformer: [String: AnyObject] -> T?, completion: Result<T, Moya.Error> -> Void) -> Cancellable {
    return service.provider.request(.Show(userID), completion: reformJSON(reformer, completion))
  }
}

extension UserManager: TokenCredentialObserverType { }