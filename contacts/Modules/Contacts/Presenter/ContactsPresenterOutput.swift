//
//  ContactsPresenterOutput.swift
//  contacts
//
//  Created by Andrei Coder on 26/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import RxSwift

protocol ContactsPresenterOutput {
  var contactsSubject: BehaviorSubject<Contacts?> { get }
  var filteredContactsSubject: BehaviorSubject<Contacts?> { get }
}
