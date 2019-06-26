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

// MARK: - ContactsRouterInput
extension ContactsRouter: ContactsRouterInput {
  
  func showError(_ title: String?, _ message: String) {
    guard let vc = vc else { return }
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    vc.present(alert, animated: true, completion: nil)
  }
  
}

// MARK: - ContactsRouterOutput
extension ContactsRouter: ContactsRouterOutput {
  
}
