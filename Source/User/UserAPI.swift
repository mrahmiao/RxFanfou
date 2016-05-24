//
//  UserAPI.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 5/24/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import Moya

extension API {

  /**
   User相关API Endpoint

   - Followers:  查询指定用户的关注者
   - Followings: 查询指定用户正在关注的用户
   - Show:       查询指定用户信息
   */
  enum User: Moya.TargetType {
    case Followers(String, Int?, Int?)
    case Followings(String, Int?, Int?)
    case Show(String)

    var baseURL: NSURL {
      return NSURL(string: "http://rest.fanfou.com/users/")!
    }

    var path: String {
      switch self {
      case .Followers(let userID, _, _):
        return "\(userID)/followers/"
      case .Followings(let userID, _, _):
        return "\(userID)/friends"
      case .Show(let userID):
        return "\(userID)"
      }
    }

    var method: Moya.Method {
      return .POST
    }

    var parameters: [String : AnyObject]? {
      switch self {
      case .Followers(_, let count, let page):
        return API.parameters(withCount: count, page: page)
      case .Followings(_, let count, let page):
        return API.parameters(withCount: count, page: page)
      case .Show(_):
        return nil
      }
    }
  }
}