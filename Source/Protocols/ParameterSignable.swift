//
//  ParameterSignable.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/23/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import CryptoSwift
import Moya

/**
 *  API Target需要实现该协议以对请求参数进行签名
 */
protocol ParameterSignable {
  /// 请求的地址
  var requestURLString: String { get }

  /// 请求的HTTP方法
  var requestMethod: String { get }

  /// 请求携带的参数
  var requestParameters: [String: AnyObject]? { get }

  /**
   使用HMAC-SHA1来计算签名

   - parameter secret App的Consumer Secret
   - parameter tokenSecret 用户授权后得到的OAuth/Access Token Secret

   - returns: 签名字符串
   */
  func calculateSignature(consumerSecret secret: String, tokenSecret: String?) -> String
}

extension ParameterSignable {

  /**
   使用HMAC-SHA1来计算签名，具体计算方法参见[OAuth签名方法](https://github.com/FanfouAPI/FanFouAPIDoc/wiki/Oauthsignature)

   - parameter secret App的Consumer Secret
   - parameter tokenSecret 用户授权后得到的OAuth/Access Token Secret

   - returns: 签名字符串
   */
  func calculateSignature(consumerSecret secret: String, tokenSecret: String?) -> String {

    guard let params = requestParameters else {
      return ""
    }

    let signatureBaseString = "\(requestMethod.uppercaseString)&\(requestURLString.ffa_urlEncodedString)&\(params.ffa_encodedQuery.ffa_urlEncodedString)"
    guard let bytes = try? Authenticator.HMAC(key: Array("\(secret)&\(tokenSecret ?? "")".utf8), variant: .sha1).authenticate(Array(signatureBaseString.utf8)) else {
      return ""
    }

    return NSData(bytes: bytes).base64EncodedStringWithOptions([])
  }
}