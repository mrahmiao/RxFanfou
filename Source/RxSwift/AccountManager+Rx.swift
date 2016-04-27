//
//  AccountManager+Rx.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/26/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import RxSwift

extension AccountManager {
  public func verifyCredentials() -> Observable<Profile> {
    return Observable.create { [weak self] observer in

      let cancellableToken = self?.verfiyCredentials { result in
        switch result {
        case .Success(let profile):
          observer.onNext(profile)
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
