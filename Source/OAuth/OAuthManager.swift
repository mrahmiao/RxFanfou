//
//  OAuthManager.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/22/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import Moya
import Result

/**
 *  饭否第三方应用的用于获取授权的元数据
 */
public struct ConsumerCredential {
  public let key: String
  public let secret: String
  public let callbackURL: String

  public init(key: String, secret: String, callbackURL: String) {
    self.key = key
    self.secret = secret
    self.callbackURL = callbackURL
  }
}

/**
 *  饭否第三方应用获得授权后的Token
 */
public struct TokenCredential {

  public static let DefaultTokenIdentifier = "com.ewstudio.RxFanfouAPI.DefaultTokenIdentifier"

  /// TokenCredential的标识符，在多用户情况下用于区分不同的Token，应该是**唯一**的
  public var identifier: String
  public let token: String
  public let tokenSecret: String

  /**
   初始化TokenCredential 对象

   - parameter identifier:  TokenCredential的标识符，在多用户情况下用于区分不同的Token，应该是**唯一**的
   - parameter token:       OAuth Token／Access Token
   - parameter tokenSecret: OAuth Token Secret／Access Token Secret

   - returns: TokenCredential
   */
  public init(identifier: String = TokenCredential.DefaultTokenIdentifier, token: String = "", tokenSecret: String = "") {
    self.identifier = identifier

    self.token = token
    self.tokenSecret = tokenSecret
  }

  /**
   使用请求OAuth Token／Access Token时返回的query字符串来初始化TokenCredential，格式为
   *oauth_token=891212-3MdIZyxPeVsFZXFOZj5tAwj6vzJYuLQplzWUmYtWd&oauth_token_secret=x6qpRnlEmW9JbQn4PQVVeVG8ZLPEx6A0TOebgwcuA*

   - parameter identifier: /// TokenCredential的标识符，在多用户情况下用于区分不同的Token，应该是**唯一**的
   - parameter query:      请求返回的oauth token／access token字符串

   - returns: 解析了token的TokenCredential
   */
  private init?(identifier: String = TokenCredential.DefaultTokenIdentifier, tokenQuery query: String) {
    guard let params = query.ffa_queryParamaters,
      token = params[APIConstants.oauthToken],
      secret = params[APIConstants.oauthTokenSecret] else {
        return nil
    }

    self.token = token
    self.tokenSecret = secret
    self.identifier = identifier
  }
}

/**
 授权类型

 - Mobile:  移动端
 - Desktop: 桌面
 */
public enum AuthorizationType: String {
  case Mobile = "http://m.fanfou.com/oauth/authorize?oauth_token=%@&oauth_callback=%@"
  case Desktop = "http://fanfou.com/oauth/authorize?oauth_token=%@&oauth_callback=%@"
}

typealias TokenCredentialUpdateHandler = (TokenCredential) -> Void

/**
 *  OAuthManager负责处理OAuth相关的请求
 */
public final class OAuthManager {

  private let consumerCredential: ConsumerCredential
  private let authorizationType: AuthorizationType
  private let service: APIService<API.OAuth>
  private let tokenCredentialUpdateHandler: TokenCredentialUpdateHandler

  private var tokenCredential: TokenCredential? {
    didSet {
      service.tokenCredential = tokenCredential
    }
  }

  init(credential: ConsumerCredential, authorizationType: AuthorizationType, tokenCredentialUpdateHandler: TokenCredentialUpdateHandler) {
    self.consumerCredential = credential
    self.authorizationType = authorizationType
    self.tokenCredentialUpdateHandler = tokenCredentialUpdateHandler
    self.service = APIService(consumerCredential: credential, tokenCredential: nil)
  }

  /**
   请求授权信息以及URL

   - parameter completion: 请求成功时，返回授权时需要打开的URL
   */
  public func requestAuthorization(completion: Result<NSURL, Moya.Error> -> Void) -> Cancellable {
    return service.provider.request(.RequestToken) { [unowned self] result in
      switch result {
      case .Success(let response):

        let query: String

        do {
          query = try response.filterSuccessfulStatusCodes().mapString()
        } catch {
          completion(.Failure(.Underlying(error)))
          return
        }

        guard let credential = TokenCredential(identifier: TokenCredential.DefaultTokenIdentifier, tokenQuery: query) else {
          completion(.Failure(.Underlying(APIErrors.IncorrectQueryString(query))))
          return
        }

        let URL = NSURL(string: String(format: self.authorizationType.rawValue, credential.token, self.consumerCredential.callbackURL))!

        self.tokenCredential = credential
        completion(.Success(URL))

      case .Failure(let error):
        completion(.Failure(error))
      }
    }
  }

  /**
   请求Access Token

   - precondition: 需要先完成`requestAuthorization(_:)`方法的调用并获取TokenCredential后才能调用该方法

   - parameter completion: 获取Access Token成功时，返回具体的`TokenCredential`

   */
  public func requestAccessToken(completion: Result<TokenCredential, Moya.Error> -> Void) -> Cancellable {

    assert(tokenCredential != nil, "tokenCredential不能为空.")

    return service.provider.request(.AccessToken) { [unowned self] result in

      switch result {
      case .Success(let response):

        let accessTokenQuery: String

        do {
          accessTokenQuery = try response.filterSuccessfulStatusCodes().mapString()
        } catch {
          completion(.Failure(.Underlying(error)))
          return
        }

        guard let credential = TokenCredential(identifier: TokenCredential.DefaultTokenIdentifier, tokenQuery:  accessTokenQuery) else {
          completion(.Failure(.Underlying(APIErrors.IncorrectQueryString(accessTokenQuery))))
          return
        }

        self.tokenCredential = credential
        self.tokenCredentialUpdateHandler(credential)

        completion(.Success(credential))

      case .Failure(let error):
        completion(.Failure(error))
      }
    }
  }
}