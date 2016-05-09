//
//  Profile.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/26/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import Gloss

/// 用户信息
public struct Profile: Decodable {

  /// ID
  public let id: String

  /// 用户名
  public let name: String

  /// 地址
  public let location: String

  /// 性别
  public let gender: String

  /// 生日
  public let birthday: String

  /// 用户自述
  public let desc: String

  /// 用户头像地址
  public let avatarImageURLString: String

  /// 用户高清头像地址
  public let avatarHDImageURLString: String

  /// 用户页面地址
  public let URLString: String

  /// 用户是否设置隐私保护
  public let protected: Bool

  /// 用户被关注数
  public let followerCount: Int

  /// 用户关注数
  public let followingCount: Int

  /// 收藏消息数
  public let favoritesCount: Int

  /// 消息数量
  public let statusCount: Int

  /// 照片数量
  public let photoCount: Int

  /// 是否正在关注当前用户
  public let following: Bool

  /// 加入饭否的时间
  public let createdAt: String

  /// UTC Offset
  public let utcOffset: Int

  /// 背景图片地址
  public let backgroundImageURL: String

  public init?(json: JSON) {
    self.id = ("id" <~~ json) ?? ""
    self.name = ("name" <~~ json) ?? ""
    self.location = ("location" <~~ json) ?? ""
    self.gender = ("gender" <~~ json) ?? ""
    self.birthday = ("birthday" <~~ json) ?? ""
    self.desc = ("description" <~~ json) ?? ""
    self.avatarImageURLString = ("profile_image_url" <~~ json) ?? ""
    self.avatarHDImageURLString = ("profile_image_url_large" <~~ json) ?? ""
    self.URLString = ("url" <~~ json) ?? ""
    self.protected = ("protected" <~~ json) ?? false
    self.followingCount = ("friends_count" <~~ json) ?? -1
    self.followerCount = ("followers_count" <~~ json) ?? -1
    self.favoritesCount = ("favourites_count" <~~ json) ?? -1
    self.statusCount = ("statuses_count" <~~ json) ?? -1
    self.photoCount = ("photo_count" <~~ json) ?? -1
    self.following = ("following" <~~ json) ?? false
    self.createdAt = ("created_at" <~~ json) ?? ""
    self.utcOffset = ("utc_offset" <~~ json) ?? -1
    self.backgroundImageURL = ("profile_background_image_url" <~~ json) ?? ""
  }
}

// MARK: - CustomStringConvertible
extension Profile: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    return [
      "ID: \(id)",
      "name: \(name)",
      "location: \(location)",
      "gender: \(gender)",
      "birthday: \(birthday)",
      "description: \(desc)",
      "avatarURL: \(avatarImageURLString)",
      "avatarHDURL: \(avatarHDImageURLString)",
      "URL: \(URLString)",
      "protected: \(protected)",
      "followerCount: \(followerCount)",
      "followingCount: \(followingCount)",
      "favoritesCount: \(favoritesCount)",
      "statusCount: \(statusCount)",
      "photoCount: \(photoCount)",
      "following: \(following)",
      "createdAt: \(createdAt)",
      "utcOffset: \(utcOffset)",
      "backgroundImageURLString: \(backgroundImageURL)"
      ].joinWithSeparator("\n")
  }

  // MARK: - CustomDebugStringConvertible
  public var debugDescription: String {
    return description
  }
}