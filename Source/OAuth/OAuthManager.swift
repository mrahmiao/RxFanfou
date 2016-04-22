//
//  OAuthManager.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/22/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation

/**
 *  饭否第三方应用的用于获取授权的元数据
 */
public struct ConsumerCredential {
  public let key: String
  public let secret: String
  public let callbackURL: String
}

/**
 *  饭否第三方应用获得授权后的Token
 */
public struct TokenCredential {
  public let oauthToken: String
  public let oauthTokenSecret: String

  public private(set) var accessToken: String?
  public private(set) var accessTokenSecret: String?
}

/**
 *  OAuthManager负责处理OAuth相关的请求
 */
struct OAuthManager {
  let consumerCredential: ConsumerCredential
}