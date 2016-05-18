//
//  AccountAPI.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/26/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import Moya

extension API {
  enum Account: Moya.TargetType {

    case VerifyCredentials
    case Notification
    case UpdateProfile(AccountManager.TargetProfile?)
    case UpdateProfileImage(NSData)

    var baseURL: NSURL {
      return NSURL(string: "http://api.fanfou.com/account/")!
    }

    var path: String {
      switch self {
      case .VerifyCredentials: return JSON("verify_credentials")
      case .Notification: return JSON("notification")
      case .UpdateProfile(_): return JSON("update_profile")
      case .UpdateProfileImage(_): return JSON("update_profile_image")
      }
    }

    var method: Moya.Method {
      return .POST
    }

    var parameters: [String : AnyObject]? {
      switch self {
      case .UpdateProfile(let profile):
        guard let profile = profile else {
          return nil
        }

        return profile.serialize()
      case .UpdateProfileImage(let imageData):
        return ["image": imageData]
      default:
        return nil
      }
    }
  }
}