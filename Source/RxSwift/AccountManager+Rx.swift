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

  public func getNotifications<T>(reformer: [String: AnyObject] -> T?) -> Observable<T> {
    return Observable.create { [weak self] observer in

      let cancellableToken = self?.getNotifications(reformer, completion: onCompletion(observer))

      return AnonymousDisposable {
        cancellableToken?.cancel()
      }
    }
  }

  public func updateProfile<T>(profile: TargetProfile, reformer: [String: AnyObject] -> T?) -> Observable<T> {
    return Observable.create { [weak self] observer in

      let cancellableToken = self?.updateProfile(profile, reformer: reformer, completion: onCompletion(observer))

      return AnonymousDisposable {
        cancellableToken?.cancel()
      }
    }
  }

  public func updateProfileImage<T>(imageData: NSData, reformer: [String: AnyObject] -> T?) -> Observable<T> {
    return Observable.create { [weak self] observer in

      let cancellableToken = self?.updateProfileImage(imageData: imageData, reformer: reformer, completion: onCompletion(observer))

      return AnonymousDisposable {
        cancellableToken?.cancel()
      }
    }
  }
}
