//
//  ApiProtocol.swift
//  contacts
//
//  Created by Andrei Coder on 21/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import RxSwift

protocol ApiProtocol {
  func loadContactsFromSource1() -> Single<[Person]>
  func loadContactsFromSource2() -> Single<[Person]>
  func loadContactsFromSource3() -> Single<[Person]>
}
