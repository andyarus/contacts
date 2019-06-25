//
//  Api.swift
//  contacts
//
//  Created by Andrei Coder on 21/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import Moya
import RxSwift

public class Api: ApiProtocol {
  private let provider: MoyaProvider<ApiProvider>
  private let disposeBag = DisposeBag()
  public static let shared = Api()
  
  public init() {
    provider = MoyaProvider<ApiProvider>()
    // debug
    //provider = MoyaProvider<ApiProvider>(plugins: [NetworkLoggerPlugin(verbose: true)])
  }
  
  func loadContactsFromSource1() -> Single<[Person]> {
    return Single.create { [unowned self] single in
      self.provider.rx.request(ApiProvider.source1)
      .filterSuccessfulStatusCodes()
      .map([Person].self)
      .catchError { error in
        single(.error(error))
        throw error
      }.subscribe(onSuccess: { contacts in
        single(.success(contacts))
      }).disposed(by: self.disposeBag)
      return Disposables.create()
    }
  }
  
  func loadContactsFromSource2() -> Single<[Person]> {
    return Single.create { [unowned self] single in
      self.provider.rx.request(ApiProvider.source2)
        .filterSuccessfulStatusCodes()
        .map([Person].self)
        .catchError { error in
          single(.error(error))
          throw error
        }.subscribe(onSuccess: { contacts in
          single(.success(contacts))
        }).disposed(by: self.disposeBag)
      return Disposables.create()
    }
  }
  
  func loadContactsFromSource3() -> Single<[Person]> {
    return Single.create { [unowned self] single in
      self.provider.rx.request(ApiProvider.source3)
        .filterSuccessfulStatusCodes()
        .map([Person].self)
        .catchError { error in
          single(.error(error))
          throw error
        }.subscribe(onSuccess: { contacts in
          single(.success(contacts))
        }).disposed(by: self.disposeBag)
      return Disposables.create()
    }
  }
  
}
