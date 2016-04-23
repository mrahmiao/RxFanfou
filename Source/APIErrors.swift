//
//  APIErrors.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/22/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation

/**
 在API调用过程中会遇到的错误

 - IncorrectQueryString: 传入的Query字符串不符合要求
 */
public enum APIErrors: ErrorType {
  case IncorrectQueryString(String)
}