//
//  ContactsModuleBuilder.swift
//  contacts
//
//  Created by Andrei Coder on 27/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import UIKit

class ContactsModuleBuilder {
  
  func build() -> UIViewController {
    let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
    let vc = sb.instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController
    
    let interactor = ContactsInteractor()
    let router = ContactsRouter(vc: vc)
    vc.presenter = ContactsPresenter(interactor: interactor, router: router)
    
    return vc
  }
  
}
