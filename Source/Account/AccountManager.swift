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

  public struct TargetProfile: Serializable {
    public var URLString: String?
    public var location: String?
    public var description: String?
    public var name: String?
    public var email: String?

    public init() { }

    func serialize() -> [String: AnyObject] {
      var result: [String: AnyObject] = [:]

      result["url"] = URLString
      result["location"] = location
      result["description"] = description
      result["name"] = name
      result["email"] = email

      return result
    }
  }

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

  public func getNotifications<T>(reformer: [String: AnyObject] -> T?, completion: Result<T, Moya.Error> -> Void) -> Cancellable {
    return service.provider.request(.Notification, completion: reformJSON(reformer, completion))
  }

  public func updateProfile<T>(profile: TargetProfile, reformer: [String: AnyObject] -> T?, completion: Result<T, Moya.Error> -> Void) -> Cancellable {
    return service.provider.request(.UpdateProfile(profile), completion: reformJSON(reformer, completion))
  }

  public func updateProfileImage<T>(imageData data: NSData, reformer: [String: AnyObject] -> T?, completion: Result<T, Moya.Error> -> Void) -> Cancellable {
    return service.provider.request(.UpdateProfileImage(data), completion: reformJSON(reformer, completion))
  }

}

extension AccountManager: TokenCredentialObserverType { }