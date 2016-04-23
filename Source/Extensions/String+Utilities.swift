//
//  String+Utilities.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/23/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation

extension String {

  /// 解析query字符串中的参数，目前仅支持最简单的foo=bar&hello=world
  public var ffa_queryParamaters: [String: String]? {
    let queries = characters.split("&")

    if queries.isEmpty {
      return nil
    }

    var result = [String: String]()

    for query in queries {
      let keyValue = query.split("=")
      result[String(keyValue[0])] = String(keyValue[1])
    }

    return result
  }
}