//
//  FriendshipManager+Rx.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 5/18/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import RxSwift

extension FriendshipManager {
  public func showFriendship(sourceName sName: String, targetName tName: String) -> Observable<FollowingStatus> {
    return Observable.create { [weak self] observer in

      let cancellableToken = self?.showFriendship(sourceName: sName, targetName: tName, completion: onCompletion(observer))

      return AnonymousDisposable {
        cancellableToken?.cancel()
      }

    }
  }

  public func showFriendship(sourcdID sID: String, targetID tID: String) -> Observable<FollowingStatus> {
    return Observable.create { [weak self] observer in

      let cancellableToken = self?.showFriendship(sourceID: sID, targetID: tID, completion: onCompletion(observer))

      return AnonymousDisposable {
        cancellableToken?.cancel()
      }
      
    }
  }

}