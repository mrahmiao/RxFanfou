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
      return NSURL(string: "http://api.fanfou.com/users/")!
    }

    var path: String {
      switch self {
      case .Followers(_):
        return JSON("followers")
      case .Followings(_):
        return JSON("friends")
      case .Show(_):
        return JSON("show")
      }
    }

    var method: Moya.Method {
      return .POST
    }

    var parameters: [String : AnyObject]? {
      switch self {
      case .Followers(let userID, let count, let page):
        var params = API.parameters(withCount: count, page: page)
        params["id"] = userID
        return params
      case .Followings(let userID, let count, let page):
        var params = API.parameters(withCount: count, page: page)
        params["id"] = userID
        return params
      case .Show(let userID):
        return [
          "id": userID
        ]
      }
    }
  }
}