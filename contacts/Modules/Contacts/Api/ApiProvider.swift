//
//  ApiProvider.swift
//  contacts
//
//  Created by Andrei Coder on 21/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import Moya

enum ApiProvider {
  case source1
  case source2
  case source3
}

extension ApiProvider: TargetType {
  
  var baseURL: URL {
    switch self {
    case .source1, .source2, .source3:
      return URL(string: "https://raw.githubusercontent.com/SkbkonturMobile/mobile-test-ios/master/json/")!
    }
  }
  
  var path: String {
    switch self {
    case .source1:
      return "generated-01.json"
    case .source2:
      return "generated-02.json"
    case .source3:
      return "generated-03.json"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .source1, .source2, .source3:
      return .get
    }
  }
  
  var task: Task {
    switch self {
    default:
      return .requestPlain
    }
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var headers: [String: String]? {
    switch self {
    default:
      return [:]
    }
  }
  
}
