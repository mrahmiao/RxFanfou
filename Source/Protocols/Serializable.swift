//
//  Serializable.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 5/18/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation

protocol Serializable {
  func serialize() -> [String: AnyObject]
}

extension Serializable {
  func serialize() -> [String: AnyObject] {
    return [:]
  }
}