//
//  FanfouAPIManager.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/22/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation

/**
 *  FanfouAPI管理器，整个SDK的入口
 */
public struct FanfouAPIManager {

  private let consumerCredential: ConsumerCredential
  private let authorizationType: AuthorizationType

  /**
   使用`ConsumerCredential`以及`AuthorizationType`来构造一个FanfouAPI管理器

   - parameter credential:        饭否第三方应用的Token
   - parameter authorizationType: 授权类型，默认为.Mobile

   - returns: 饭否API管理器
   */
  public init(credential: ConsumerCredential, authorizationType: AuthorizationType = .Mobile) {
    self.consumerCredential = credential
    self.authorizationType = authorizationType
  }

  /// 通过`OAuth`调用授权相关的API
  public private(set) lazy var OAuth: OAuthManager = {
    return OAuthManager(credential: self.consumerCredential, authorizationType: self.authorizationType)
  }()
}

/**
 *  Fanfou API的命名空间
 */
struct API { }