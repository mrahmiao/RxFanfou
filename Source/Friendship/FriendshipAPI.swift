//
//  FriendshipAPI.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 5/18/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import Moya

extension API {
  enum Friendship: Moya.TargetType {
    case ShowByName(String, String)
    case ShowByID(String, String)

    var baseURL: NSURL {
      return NSURL(string: "http://api.fanfou.com/friendships/")!
    }

    var path: String {
      switch self {
      case .ShowByName(_), .ShowByID(_):
        return JSON("show")
      }
    }

    var method: Moya.Method {
      return .POST
    }

    var parameters: [String : AnyObject]? {
      switch self {
      case .ShowByName(let sourceName, let targetName):
        return [
          "source_login_name": sourceName,
          "target_login_name": targetName
        ]
      case .ShowByID(let sourceID, let targetID):
        return [
          "source_id": sourceID,
          "target_id": targetID
        ]
      }
    }
  }
}