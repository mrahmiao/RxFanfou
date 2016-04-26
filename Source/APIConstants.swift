//
//  APIConstants.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/23/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation

public struct APIConstants {
  // 请求返回的字符串中相关数据的key值
  public static let accessToken = "access_token"
  public static let accessTokenSecret = "access_token_secret"

  static let oauthToken = "oauth_token"
  static let oauthTokenSecret = "oauth_token_secret"
  static let oauthConsumerKey = "oauth_consumer_key"
  static let oauthSignatureMethod = "oauth_signature_method"
  static let oauthSignature = "oauth_signature"
  static let oauthTimestamp = "oauth_timestamp"
  static let oauthNonce = "oauth_nonce"
}