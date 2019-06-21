//
//  ContactsViewController.swift
//  contacts
//
//  Created by Andrei Coder on 21/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import UIKit
import RxSwift

class ContactsViewController: UIViewController {
  
  var disposeBag = DisposeBag()
  var contacts: [Person] = []
  
  var refreshControl: UIRefreshControl!
  
  @IBOutlet var contactsTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    contactsTableView.tableFooterView = UIView() // hide empty separators
    
    refreshControl = UIRefreshControl()
    refreshControl.tintColor = .lightGray
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    contactsTableView.addSubview(refreshControl)
    
    loadData()
  }
  
  func loadData() {
    //refreshControl.beginRefreshing()
    refresh()
  }
  
  @objc func refresh() {
    //errorView.isHidden = true
    
    var contactsTmp: [Person] = []
    
    Api.shared.loadContactsFromSource1()
      .subscribe(onSuccess: { [unowned self] contacts in
        contactsTmp.append(contentsOf: contacts)
        
        Api.shared.loadContactsFromSource2()
          .subscribe(onSuccess: { [unowned self] contacts in
            contactsTmp.append(contentsOf: contacts)
            
            Api.shared.loadContactsFromSource3()
              .subscribe(onSuccess: { [unowned self] contacts in
                contactsTmp.append(contentsOf: contacts)

//                // unique
//                contactsTmp.forEach { contact in
//                  if !self.contacts.contains(where: { $0.id == contact.id } ) {
//                    self.contacts.append(contact)
//                  }
//                }

                self.contacts = contactsTmp
                self.contacts.sort {
                  $0.name ?? "" < $1.name ?? ""
                }
                
                self.refreshControl.endRefreshing()
                self.contactsTableView.reloadData()
                
                }, onError: { [unowned self] (error) in
                  self.refreshFailed()
              }).disposed(by: self.disposeBag)
            
          }, onError: { [unowned self] (error) in
            self.refreshFailed()
        }).disposed(by: self.disposeBag)

      }, onError: { [unowned self] (error) in
        self.refreshFailed()
    }).disposed(by: self.disposeBag)
    
  }
  
  func refreshFailed() {
    //errorView.isHidden = false
    refreshControl.endRefreshing()
    contactsTableView.reloadData()
  }
  
  func formatted(phone value: String?) -> String {
    guard var phone = value else { return String() }
    phone = phone.replacingOccurrences(of: "(", with: "")
    phone = phone.replacingOccurrences(of: ")", with: "")
    if phone.count > 13 {
      let idx = phone.index(phone.startIndex, offsetBy: 13)
      if phone[idx] != "-" {
        phone.insert("-", at: phone.index(phone.startIndex, offsetBy: 13))
      }
    }
    
    return phone
  }
  
  func formatted(temperament value: String?) -> String {
    guard var temperament = value else { return String() }
    temperament = temperament.prefix(1).capitalized + temperament.dropFirst()
    
    return temperament
  }
  
}

extension ContactsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contacts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath) as! ContactsCell
    
    let person = contacts[indexPath.row]
    cell.nameLabel.text = person.name
    cell.phoneLabel.text = formatted(phone: person.phone)
    cell.temperamentLabel.text = formatted(temperament: person.temperament?.rawValue)
    
    return cell
  }
  
}

extension ContactsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
}
