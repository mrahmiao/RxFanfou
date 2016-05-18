//
//  FollowingStatus.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 5/12/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation

/**
 双方关注情况

 - None:          双方都没有关注对方
 - BeingFollowed: 有一方被关注，associated value是被关注者的loginName或者ID
 - Bidirection:   双方互相关注对方
 */
public enum FollowingStatus {
  case None
  case BeingFollowed(String)
  case Bidirection
}