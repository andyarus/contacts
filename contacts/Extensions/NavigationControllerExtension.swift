//
//  NavigationControllerExtension.swift
//  contacts
//
//  Created by Andrei Coder on 27/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import UIKit

extension UINavigationController {
  
  override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    get {
      
//      if visibleViewController is ContactsViewController {
//        return .portrait
//      } else if visibleViewController is ProfileViewController {
//        return .portrait
//      }
      
      return super.supportedInterfaceOrientations
    }
  }
  
}
