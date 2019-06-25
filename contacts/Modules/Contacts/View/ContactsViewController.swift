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
  
  var networkErrorsCount = 0
  var testErrorView = false // change for testing loading error notification
  
  let headerBackgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
  let searchBarBackgroundColor = UIColor(red: 232/255, green: 232/255, blue: 233/255, alpha: 1)
  
  var refreshControl: UIRefreshControl!
  
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var contactsTableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var errorView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    setupHeaderView()
    setupTableView()
    loadData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // change tint color
    navigationController?.navigationBar.barTintColor = headerBackgroundColor
  }
  
  func setupNavigationBar() {
    // remove "Back"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    // hide bottom border
    navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  func setupHeaderView() {
    headerView.backgroundColor = headerBackgroundColor
    
    searchBar.backgroundImage = UIImage()
    searchBar.barTintColor = UIColor()
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = searchBarBackgroundColor
  }
  
  func setupTableView() {
    // hide empty separators
    contactsTableView.tableFooterView = UIView()
    
    // add refresh control
    refreshControl = UIRefreshControl()
    refreshControl.tintColor = .lightGray
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    contactsTableView.addSubview(refreshControl)
  }
  
  func loadData() {
    activityIndicator.startAnimating()
    refresh()
  }
  
  @objc func refresh() {
    errorView.isHidden = true
    contactsTableView.isUserInteractionEnabled = false
    
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
                
                // test only
                if self.testErrorView {
                  self.networkErrorsCount += 1
                  if self.networkErrorsCount % 2 == 0 {
                    self.refreshFailed()
                    return
                  }
                }
                
                self.contacts = contactsTmp
                self.contacts.sort {
                  $0.name ?? "" < $1.name ?? ""
                }
                
                self.refreshFinished()
                
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
  
  func refreshFinished() {
    refreshControl.endRefreshing()
    activityIndicator.stopAnimating()
    contactsTableView.reloadData()
    contactsTableView.isUserInteractionEnabled = true
  }
  
  func refreshFailed() {
    errorView.isHidden = false
    refreshFinished()
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
    cell.phoneLabel.text = Utils.shared.format(phone: person.phone)
    cell.temperamentLabel.text = Utils.shared.format(temperament: person.temperament?.rawValue)
    
    return cell
  }
  
}

extension ContactsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let person = contacts[indexPath.row]
    let sb = UIStoryboard.init(name: "Main", bundle: nil)
    guard let vc = sb.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { return }
    vc.person = person    
    navigationController?.pushViewController(vc, animated: true)
    
    errorView.isHidden = true
  }
  
}
