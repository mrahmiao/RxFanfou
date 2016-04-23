//
//  OAuthAPI.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/22/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import Moya

extension API {

  /**
   OAuth的相关API

   - RequestToken: 获取OAuth Token以及授权URL
   - AccessToken:  获取Access Token
   */
  enum OAuth {
    case RequestToken
    case AccessToken
  }
}

extension API.OAuth: TargetType {
  var baseURL: NSURL {
    return NSURL(string: "http://fanfou.com/oauth")!
  }

  var path: String {
    switch self {
    case .RequestToken: return "/request_token"
    case .AccessToken: return "/access_token"
    }
  }

  var method: Moya.Method {
    return .POST
  }

  var parameters: [String: AnyObject]? {
    return [:]
  }

  var sampleData: NSData {
    return NSData()
  }
}