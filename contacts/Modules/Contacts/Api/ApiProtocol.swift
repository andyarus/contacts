//
//  ApiProtocol.swift
//  contacts
//
//  Created by Andrei Coder on 21/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import RxSwift

protocol ApiProtocol {
  func loadContactsFromSource1() -> Single<PersonJson>
  func loadContactsFromSource2() -> Single<PersonJson>
  func loadContactsFromSource3() -> Single<PersonJson>
}
