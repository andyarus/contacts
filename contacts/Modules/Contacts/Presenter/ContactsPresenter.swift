//
//  ContactsPresenter.swift
//  contacts
//
//  Created by Andrei Coder on 26/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import RxSwift

class ContactsPresenter {
  
  // MARK: - Properties
  let interactor: ContactsInteractorInput & ContactsInteractorOutput
  let router: ContactsRouterInput & ContactsRouterOutput
  
  private let disposeBag = DisposeBag()
  
  var contactsSubject = BehaviorSubject<Contacts?>(value: nil)
  var filteredContactsSubject = BehaviorSubject<Contacts?>(value: nil)
  
  // MARK: - Init
  init(interactor: ContactsInteractorInput & ContactsInteractorOutput, router: ContactsRouterInput & ContactsRouterOutput) {
    self.interactor = interactor
    self.router = router
    
    initSubscribes()
  }
  
  // MARK: - Methods
  private func initSubscribes() {
    interactor.contactsSubject
      .filter { $0 != nil }
      .map { $0! }
      .subscribe(onNext: { [unowned self] result in
        self.contactsSubject.onNext(result)
        
//        switch result {
//        case .success:
//          break
//        case .error(let error):
//          self.router.showError(nil, error)
//        }
      }).disposed(by: disposeBag)
    
    interactor.filteredContactsSubject
      .filter { $0 != nil }
      .map { $0! }
      .subscribe(onNext: { [unowned self] result in
        self.filteredContactsSubject.onNext(result)
        
//        switch result {
//        case .success:
//          break
//        case .error(let error):
//          self.router.showError(nil, error)
//        }
      }).disposed(by: disposeBag)
  }

}

// MARK: - ContactsPresenterInput
extension ContactsPresenter: ContactsPresenterInput {
  
  func loadContacts() {
    interactor.loadContacts()
  }
  
  func filterContentForSearchText(_ searchText: String) {
    interactor.filterContentForSearchText(searchText)
  }
  
}

// MARK: - ContactsPresenterOutput
extension ContactsPresenter: ContactsPresenterOutput {
  
}
