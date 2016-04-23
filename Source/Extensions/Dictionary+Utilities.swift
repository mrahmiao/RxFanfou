//
//  Dictionary+Utilities.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/23/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation

extension Dictionary where Key: StringLiteralConvertible {
  public var ffa_encodedQuery: String {
    var parts = [String]()

    for (key, value) in self {
      parts.append("\(String(key).ffa_urlEncodedString)=\(String(value).ffa_urlEncodedString)")
    }

    return parts.sort({$0 < $1}).joinWithSeparator("&")
  }
}