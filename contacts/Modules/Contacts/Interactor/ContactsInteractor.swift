//
//  ContactsInteractor.swift
//  contacts
//
//  Created by Andrei Coder on 26/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import RxSwift

class ContactsInteractor {

}

extension ContactsInteractor: ContactsInteractorInput {
  
  func loadContactsFromNetwork() {
    print("loadContactsFromNetwork")
  }
  
  func loadContactsFromLocal() {
    print("loadContactsFromLocal")
  }
}


extension ContactsInteractor: ContactsInteractorOutput {
  
}
