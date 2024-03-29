//
//  ContactsInteractorOutput.swift
//  contacts
//
//  Created by Andrei Coder on 26/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import RxSwift

protocol ContactsInteractorOutput {
  var contactsSubject: BehaviorSubject<Contacts?> { get }
  var filteredContactsSubject: BehaviorSubject<Contacts?> { get }
}
