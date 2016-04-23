//
//  APIService.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/23/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import CryptoSwift
import Moya

final class APIService<T: Moya.TargetType> {

  private let consumerCredential: ConsumerCredential
  var tokenCredential: TokenCredential?

  private(set) lazy var provider: MoyaProvider<T> = {
    return MoyaProvider(endpointClosure: { [unowned self] target -> Endpoint<T> in

      // 添加公共参数，具体参见[Fanfou OAuth](https://github.com/FanfouAPI/FanFouAPIDoc/wiki/Oauth)
      var parameters = target.parameters ?? [:]

      /*
       * 设置OAuth Token/Access Token
       * 如果TokenCredential中存在Access Token，为一般API调用请求
       * 在发送OAuth的API调用请求时，第一步请求授权URL时没有OAuth Token，第二步请求Access Token时才有
       * OAuth Token，之后OAuth过程结束，进入一般API调用过程
       */
      if let token = self.tokenCredential?.accessToken ?? self.tokenCredential?.oauthToken {
        parameters[APIConstants.oauthToken] = token
      }

      parameters[APIConstants.oauthConsumerKey] = self.consumerCredential.key
      parameters[APIConstants.oauthSignatureMethod] = "HMAC-SHA1"
      parameters[APIConstants.oauthTimestamp] = "\(NSDate().timeIntervalSince1970)"

      let UUID = NSUUID().UUIDString
      parameters[APIConstants.oauthNonce] = UUID.substringToIndex(UUID.startIndex.advancedBy(8))

      let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString

      return Endpoint(URL: url, sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: parameters)
    }, requestClosure: { [unowned self] (endpoint, closure) in

      /*
       * 获取OAuth Token Secret / Access Token Secret以对参数进行签名
       */
      let tokenSecret = self.tokenCredential?.accessTokenSecret ?? self.tokenCredential?.oauthTokenSecret ?? ""
      let targetEndpoint = endpoint.endpointByAddingParameters([
        APIConstants.oauthSignature: endpoint.calculateSignature(
        consumerSecret: self.consumerCredential.secret,
        tokenSecret: tokenSecret)
      ])

      closure(targetEndpoint.urlRequest)
    })
  }()

  init(consumerCredential: ConsumerCredential, tokenCredential: TokenCredential?) {
    self.consumerCredential = consumerCredential
    self.tokenCredential = tokenCredential
  }
}

extension Moya.Endpoint: ParameterSignable {
  var requestURLString: String {
    return URL
  }

  var requestMethod: String {
    return method.rawValue.uppercaseString
  }

  var requestParameters: [String: AnyObject]? {
    return parameters
  }
}