//
//  APIErrors.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 4/22/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation

/**
 *  API中会遇到的错误
 */
public struct APIErrors {

  /**
   通用错误类型

   - Unknown: 未知错误
   */
  public enum Common: ErrorType {
    case Unknown
  }

  /**
   网络请求错误类型

   - Client: 客户端错误，associated value是其响应状态码
   - Server: 服务端错误，associated value是其响应状态码
   */
  public enum Network: ErrorType {
    case Client(Int)
    case Server(Int)
  }
}