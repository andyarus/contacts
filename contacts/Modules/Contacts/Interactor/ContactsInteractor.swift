//
//  ContactsInteractor.swift
//  contacts
//
//  Created by Andrei Coder on 26/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import RxSwift

class ContactsInteractor {
  
  // MARK: - Properties
  private var disposeBag = DisposeBag()
  private var dataService: DataService = DataService()
  
  var contactsSubject = BehaviorSubject<Contacts?>(value: nil)
  var filteredContactsSubject = BehaviorSubject<Contacts?>(value: nil)
  
  // test only
  // MARK: - Test Properties
  var networkErrorsCount = 0
  var testErrorView = false // change for testing loading error notification
  
  // MARK: - Methods
  func loadFromNetworkFailed() {
    self.contactsSubject.onNext(.error(error: "load from network failed"))
  }
  
  func loadFromLocalStorageFailed() {
    self.contactsSubject.onNext(.error(error: "load from local storage failed"))
  }

}

// MARK: - ContactsInteractorInput
extension ContactsInteractor: ContactsInteractorInput {
  
  func loadContacts() {
    
    // use local storage if time left < lastUpdateTimeLimit
    if !dataService.isUpdateTimeLimitExceeded() {
      let contacts = dataService.getContacts()
      
      // test only
      if testErrorView {
        networkErrorsCount += 1
        if networkErrorsCount % 5 == 0 {
          loadFromLocalStorageFailed()
          return
        }
      }
      
      contactsSubject.onNext(.success(contacts: Array(contacts)))
      return
    }
    
    var contactsAll: [Person] = []
    
    Api.shared.loadContactsFromSource1()
      .subscribe(onSuccess: { [unowned self] contacts in
        contactsAll.append(contentsOf: contacts)
        
        Api.shared.loadContactsFromSource2()
          .subscribe(onSuccess: { [unowned self] contacts in
            contactsAll.append(contentsOf: contacts)
            
            // test only
            if self.testErrorView {
              self.networkErrorsCount += 1
              if self.networkErrorsCount % 3 == 0 {
                self.loadFromNetworkFailed()
                return
              }
            }
            
            Api.shared.loadContactsFromSource3()
              .subscribe(onSuccess: { [unowned self] contacts in
                contactsAll.append(contentsOf: contacts)
                
                contactsAll.sort {
                  $0.name ?? "" < $1.name ?? ""
                }
                
                let contacts = self.dataService.update(contactsAll)
                self.contactsSubject.onNext(.success(contacts: Array(contacts)))
                
                }, onError: { [unowned self] (error) in
                  self.loadFromNetworkFailed()
              }).disposed(by: self.disposeBag)
            
            }, onError: { [unowned self] (error) in
              self.loadFromNetworkFailed()
          }).disposed(by: self.disposeBag)
        
        }, onError: { [unowned self] (error) in
          self.loadFromNetworkFailed()
      }).disposed(by: self.disposeBag)
    
  }
  
  func filterContentForSearchText(_ searchText: String) {
    let contacts = dataService.getContacts()
    let filteredContacts = contacts.filter({(person : PersonDataModel) -> Bool in
      return Utils.shared.format(nameSearch: person.name).contains(Utils.shared.format(nameSearch: searchText)) || Utils.shared.format(phoneSearch: person.phone).contains(Utils.shared.format(phoneSearch: searchText))
    })
    
    filteredContactsSubject.onNext(.success(contacts: Array(filteredContacts)))
  }
  
}

// MARK: - ContactsInteractorOutput
extension ContactsInteractor: ContactsInteractorOutput {
  
}
