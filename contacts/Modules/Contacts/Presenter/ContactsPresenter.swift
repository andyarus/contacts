//
//  ContactsPresenter.swift
//  contacts
//
//  Created by Andrei Coder on 26/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import RxSwift

class ContactsPresenter {
  
  let interactor: ContactsInteractorInput & ContactsInteractorOutput
  let router: ContactsRouterInput & ContactsRouterOutput
  
  init(interactor: ContactsInteractorInput & ContactsInteractorOutput, router: ContactsRouterInput & ContactsRouterOutput) {
    self.interactor = interactor
    self.router = router
  }

}

extension ContactsPresenter: ContactsPresenterInput {
  
  func loadContacts(from datasource: DataSource) {
    switch datasource {
    case .network:
      print("network")
    case .local:
      print("local")
    }
  }
  
}

extension ContactsPresenter: ContactsPresenterOutput {
  
}
