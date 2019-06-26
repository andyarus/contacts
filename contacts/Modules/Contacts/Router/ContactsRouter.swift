//
//  ContactsRouter.swift
//  contacts
//
//  Created by Andrei Coder on 26/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import UIKit

class ContactsRouter {
  weak var vc: UIViewController?
  
  init(vc: UIViewController) {
    self.vc = vc
  }
}

extension ContactsRouter: ContactsRouterInput {
  
}

extension ContactsRouter: ContactsRouterOutput {
  
}
