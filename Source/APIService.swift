//
//  APIService.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/23/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import CryptoSwift
import Gloss
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
       * 1. 在请求授权URL时应为空
       * 2. 在请求Access Token时应为上一步获得的OAuth Token
       * 3. 在进行普通API调用时应为Access Token
       */
      if let token = self.tokenCredential?.token {
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
         * 获取OAuth Token Secret / Access Token Secret
         * 1. 在获取授权URL时，应为空
         * 2. 在获取Access Token时，应为OAuth Token Secret
         * 3. 在进行普通API调用时，应为Access Token Secret
         */
        let tokenSecret = self.tokenCredential?.tokenSecret ?? ""

        // 利用Token Secret对参数进行签名
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

extension Moya.TargetType {

  var parameters: [String: AnyObject]? {
    return [:]
  }

  var sampleData: NSData {
    return NSData()
  }

  func JSON(path: String) -> String {
    return "\(path).json"
  }
}

extension Moya.Response {
  func mapSuccessfulHTTPObject<T: Decodable>(type: T.Type) throws -> T {

    let res = try filterStatusCode(200)

    guard let JSON = try NSJSONSerialization.JSONObjectWithData(res.data, options: .AllowFragments) as? [String: AnyObject] else {
      throw Moya.Error.JSONMapping(res)
    }

    guard let instance = type.init(json: JSON) else {
      throw Moya.Error.Data(res)
    }

    return instance
  }
}