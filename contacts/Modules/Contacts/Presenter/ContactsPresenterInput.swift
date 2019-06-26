//
//  ContactsPresenterInput.swift
//  contacts
//
//  Created by Andrei Coder on 26/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import Foundation

protocol ContactsPresenterInput {
  func loadContacts()
  func filterContentForSearchText(_ searchText: String)
}
