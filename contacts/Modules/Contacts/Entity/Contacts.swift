//
//  Contacts.swift
//  contacts
//
//  Created by Andrei Coder on 27/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import Foundation

enum Contacts {
  case success(contacts: [PersonDataModel])
  case error(error: String)
}
