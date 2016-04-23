//
//  FanfouAPIManager.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/22/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import Log

/// 全局用日志
let logger = Logger()

/**
 *  SDK入口
 */
public struct FanfouAPIManager {

  private let consumerCredential: ConsumerCredential
  private let authorizationType: AuthorizationType

  public init(credential: ConsumerCredential, authorizationType: AuthorizationType = .Mobile) {
    self.consumerCredential = consumerCredential
    self.authorizationType = authorizationType
  }

  public private(set) lazy var OAuth: OAuthManager {
    return OAuthManager(credential: consumerCredential, authorizationType: authorizationType)
  }
}

/**
 *  Fanfou API的命名空间
 */
struct API { }