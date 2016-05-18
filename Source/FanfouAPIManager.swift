//
//  FanfouAPIManager.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/22/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import Result
import Moya

/**
 *  FanfouAPI管理器，整个SDK的入口
 */
public final class FanfouAPIManager {

  private let consumerCredential: ConsumerCredential
  private let authorizationType: AuthorizationType
  var credentialObservers: [TokenCredentialObserverType] = []

  /// 授权信息，调用API之前tokenCredential必须不为空，且AccessToken/AccessTokenSecret俱全
  public var tokenCredential: TokenCredential {
    didSet {
      // tokenCredential时，通知各个Observer进行更新
      notify(tokenCredential)
    }
  }

  /**
   使用`ConsumerCredential`以及`AuthorizationType`来构造一个FanfouAPI管理器

   - parameter credential:        饭否第三方应用的Token
   - parameter tokenCredential:   应用授权信息
   - parameter authorizationType: 授权类型，默认为.Mobile

   - returns: 饭否API管理器
   */
  public init(credential: ConsumerCredential, tokenCredential: TokenCredential? = nil, authorizationType: AuthorizationType = .Mobile) {
    self.consumerCredential = credential
    self.tokenCredential = tokenCredential ?? TokenCredential(identifier: TokenCredential.DefaultTokenIdentifier)
    self.authorizationType = authorizationType
  }

  /// 通过`OAuth`调用授权相关的API
  public private(set) lazy var OAuth: OAuthManager = {
    return OAuthManager(
      credential: self.consumerCredential, authorizationType: self.authorizationType,
      tokenCredentialUpdateHandler: { [weak self] credential in
        self?.tokenCredential = credential
      })
  }()

  /// 调用Account相关API
  public private(set) lazy var Account: AccountManager = {
    return AccountManager(consumerCredential: self.consumerCredential,
                          tokenCredential: self.tokenCredential)
  }()
}

/**
 *  实现该协议以添加TokenCredential的Observer
 */
protocol TokenCredentialObservable {
  var credentialObservers: [TokenCredentialObserverType] { get set }
  func addCredentialObserver(observer: TokenCredentialObserverType)
  func notify(tokenCredential: TokenCredential?)
}

extension FanfouAPIManager: TokenCredentialObservable {
  func addCredentialObserver(observer: TokenCredentialObserverType) {
    credentialObservers.append(observer)
  }

  func notify(tokenCredential: TokenCredential?) {
    for observer in credentialObservers {
      observer.updateCredential(tokenCredential)
    }
  }
}

/**
 *  各个API Manager实现该协议，并添加自己为Observer，在TokenCredential更新时获得通知
 */
protocol TokenCredentialObserverType {
  func updateCredential(credential: TokenCredential?)
}

// MARK: - APIManagerType
protocol APIManagerType {
  var consumerCredential: ConsumerCredential { get set }
  var tokenCredential: TokenCredential { get set }
  init(consumerCredential: ConsumerCredential, tokenCredential: TokenCredential)
}

extension APIManagerType where Self: TokenCredentialObserverType {
  init(consumerCredential: ConsumerCredential, tokenCredential: TokenCredential, tokenCredentialObservable: TokenCredentialObservable) {
    self.init(consumerCredential: consumerCredential, tokenCredential: tokenCredential)
    tokenCredentialObservable.addCredentialObserver(self)
  }
}

extension APIManagerType {
  func reformJSON<T>(reformer: [String: AnyObject] -> T?, _ completion: Result<T, Error> -> Void) -> Result<Response, Error> -> Void {
  return { result in
      switch result {
      case .Success(let response):
        do {
          let object = try response.reformSuccessfulHTTPResponse(reformer)
          completion(.Success(object))
        } catch {
          completion(.Failure(.Underlying(error)))
        }

      case .Failure(let e):
        completion(.Failure(.Underlying(e)))
      }
    }
  }
}

/**
 *  Fanfou API的命名空间
 */
struct API { }