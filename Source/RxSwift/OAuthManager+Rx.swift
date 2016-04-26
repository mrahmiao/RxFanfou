//
//  OAuthManager+Rx.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/23/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import RxSwift

public extension OAuthManager {
  /**
   请求授权信息以及URL

   - returns: 包含授权信息的TokenCredential对象以及授权URL
   */
  public func requestAuthorization() -> Observable<NSURL> {
    return Observable.create { [weak self] observer in
      let cancellableToken = self?.requestAuthorization { result in
        switch result {
        case .Success(let response):
          observer.onNext(response)
          observer.onCompleted()
        case .Failure(let error):
          observer.onError(error)
        }
      }

      return AnonymousDisposable {
        cancellableToken?.cancel()
      }
    }
  }

  /**
   请求Access Token

   - returns: 包含Access Token以及Access Token Secret的TokenCredential对象
   */
  public func requestAccessToken() -> Observable<TokenCredential> {
    return Observable.create { [weak self] observer in
      let cancellableToken = self?.requestAccessToken { result in
        switch result {
        case .Success(let credential):
          observer.onNext(credential)
          observer.onCompleted()
        case .Failure(let error):
          observer.onError(error)
        }
      }

      return AnonymousDisposable {
        cancellableToken?.cancel()
      }
    }
  }
}
