//
//  Theme.swift
//  contacts
//
//  Created by Andrei Coder on 27/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import UIKit

class Theme {
  
  static let shared = Theme()
  
  struct Contacts {
    
    struct NavigationBar {
      struct Background {
        static var color: UIColor {
          return UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        }
      }
    }
    
    struct SearchBar {
      struct Background {
        static var color: UIColor {
          return UIColor(red: 232/255, green: 232/255, blue: 233/255, alpha: 1)
        }
      }
    }
    
  }
  
  struct Profile {
    
    struct NavigationBar {
      struct Tint {
        static var color: UIColor {
          return UIColor(red: 250/255, green: 249/255, blue: 255/255, alpha: 1)
        }
      }
    }
    
  }

}
