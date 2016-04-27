//
//  AccountManager.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/26/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import Moya
import Result

public final class AccountManager: APIManagerType {

  var consumerCredential: ConsumerCredential
  var tokenCredential: TokenCredential
  let service: APIService<API.Account>

  init(consumerCredential: ConsumerCredential, tokenCredential: TokenCredential) {
    self.consumerCredential = consumerCredential
    self.tokenCredential = tokenCredential
    self.service = APIService(consumerCredential: consumerCredential, tokenCredential: tokenCredential)
  }

  public func verfiyCredentials(completion: Result<Profile, Moya.Error> -> Void) -> Cancellable {
    return service.provider.request(.VerifyCredentials) { result in
      switch result {
      case .Success(let response):
        do {
          let profile = try response.mapSuccessfulHTTPObject(Profile.self)
          completion(.Success(profile))
        } catch {
          completion(.Failure(.Underlying(error)))
        }

      case .Failure(let e):
        completion(.Failure(e))
      }
    }
  }

}