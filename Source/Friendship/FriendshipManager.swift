//
//  FriendshipManager.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 5/18/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import Moya
import Result

public final class FriendshipManager: APIManagerType {

  var consumerCredential: ConsumerCredential
  var tokenCredential: TokenCredential
  let service: APIService<API.Friendship>

  init(consumerCredential: ConsumerCredential, tokenCredential: TokenCredential) {
    self.consumerCredential = consumerCredential
    self.tokenCredential = tokenCredential
    self.service = APIService(consumerCredential: consumerCredential, tokenCredential: tokenCredential)
  }

  public func showFriendship(sourceName sName: String, targetName tName: String, completion: Result<FollowingStatus, Error> -> Void) -> Cancellable {
    return service.provider.request(.ShowByName(sName, tName)) { [weak self] result in
      switch result {
      case .Success(let response):
        self?.handleFriendshipResponse(response, source: sName, target: tName, completion: completion)
      case .Failure(let e):
        completion(.Failure(.Underlying(e)))
      }
    }
  }

  public func showFriendship(sourceID sID: String, targetID tID: String, completion: Result<FollowingStatus, Error> -> Void) -> Cancellable {
    return service.provider.request(.ShowByID(sID, tID)) { [weak self] result in
      switch result {
      case .Success(let response):
        self?.handleFriendshipResponse(response, source: sID, target: tID, completion: completion)
      case .Failure(let e):
        completion(.Failure(.Underlying(e)))
      }
    }
  }
}

private extension FriendshipManager {
  func handleFriendshipResponse(response: Moya.Response, source: String, target: String, completion: Result<FollowingStatus, Error> -> Void) {
    let sourceInfo: [String: AnyObject]

    do {
      guard let root = try response.mapJSON() as? [String: AnyObject],
        relationship = root["relationship"] as? [String: AnyObject],
        source = relationship["source"] as? [String: AnyObject] else {
          completion(.Failure(.JSONMapping(response)))
          return
      }

      sourceInfo = source

    } catch {
      completion(.Failure(.Underlying(error)))
      return
    }

    guard let following = sourceInfo["following"] as? String,
      beingFollowed = sourceInfo["followed_by"] as? String else {
        completion(.Failure(.JSONMapping(response)))
        return
    }

    switch (following == "true", beingFollowed == "true") {
    case (true, true):
      completion(.Success(.Bidirection))
    case (true, false):
      completion(.Success(.BeingFollowed(target)))
    case (false, true):
      completion(.Success(.BeingFollowed(source)))
    case (false, false):
      completion(.Success(.None))
    }
  }
}