//
//  Utilities+Rx.swift
//  RxFanfouAPI
//
//  Created by mrahmiao on 5/18/16.
//  Copyright © 2016 EWStudio. All rights reserved.
//

import Foundation
import RxSwift
import Result
import Moya

/**
 用于简化Observable的创建过程

 - parameter observer: 信号订阅者
 */
func onCompletion<T>(observer: AnyObserver<T>) -> Result<T, Error> -> Void {
  return { result in
    switch result {
    case .Success(let object):
      observer.onNext(object)
      observer.onCompleted()
    case .Failure(let error):
      observer.onError(error)
    }
  }
}
