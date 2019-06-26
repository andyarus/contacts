//
//  ContactsViewController.swift
//  contacts
//
//  Created by Andrei Coder on 21/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class ContactsViewController: UIViewController {
  
  // MARK: - Properties
  var disposeBag = DisposeBag()
  
  let realm = try! Realm()
  lazy var contacts: Results<PersonDataModel> = { self.realm.objects(PersonDataModel.self) }()
  var filteredContacts: [PersonDataModel] = []
  let lastUpdateTimeLimit: TimeInterval = 60 // seconds
  
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
  
  // MARK: - View Setup
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
  
  // MARK: - Methods
  func loadData() {
    let lastUpdate = realm.objects(LastUpdateDataModel.self).first
    if let lastUpdate = lastUpdate,
      Date().timeIntervalSince1970 - lastUpdate.time.timeIntervalSince1970 < lastUpdateTimeLimit {
      contactsTableView.reloadData()
    } else {
      activityIndicator.startAnimating()
      refresh()
    }
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
                
                //self.contacts = contactsTmp
                contactsTmp.sort {
                  $0.name ?? "" < $1.name ?? ""
                }
                
                self.update(contactsTmp)
                
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
  
  func update(_ contacts: [Person]) {
    try! self.realm.write() {
      // delete previous contacts
      self.realm.delete(self.contacts)
      
      // add records
      for person in contacts {
        let newPerson = PersonDataModel()
        newPerson.id = person.id ?? ""
        newPerson.name = person.name ?? ""
        newPerson.phone = person.phone ?? ""
        newPerson.height = Double(person.height ?? 0.0)
        newPerson.biography = person.biography ?? ""
        newPerson.temperament = person.temperament?.rawValue ?? ""
        newPerson.educationPeriod = EducationPeriodDataModel()
        newPerson.educationPeriod?.start = person.educationPeriod?.start ?? ""
        newPerson.educationPeriod?.end = person.educationPeriod?.end ?? ""
        
        self.realm.add(newPerson)
      }
      
      // save last update time
      let lastUpdate = LastUpdateDataModel()
      lastUpdate.time = Date()
      self.realm.add(lastUpdate, update: true)
    }
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
  
  // MARK: - Search methods
  func isFiltering() -> Bool {
    return !searchBarIsEmpty()
  }
  
  func searchBarIsEmpty() -> Bool {
    return searchBar.text?.isEmpty ?? true
  }
  
  func filterContentForSearchText(_ searchText: String) {
    filteredContacts = contacts.filter({(person : PersonDataModel) -> Bool in
      return Utils.shared.format(nameSearch: person.name).contains(Utils.shared.format(nameSearch: searchText)) || Utils.shared.format(phoneSearch: person.phone).contains(Utils.shared.format(phoneSearch: searchText))
    })
    
    contactsTableView.reloadData()
  }
  
}

// MARK: - UITableViewDataSource
extension ContactsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering() {
      return filteredContacts.count
    }
    
    return contacts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath) as! ContactsCell
    let person: PersonDataModel
    if isFiltering() {
      person = filteredContacts[indexPath.row]
    } else {
      person = contacts[indexPath.row]
    }
    
    cell.nameLabel.text = person.name
    cell.phoneLabel.text = Utils.shared.format(phone: person.phone)
    cell.temperamentLabel.text = Utils.shared.format(temperament: person.temperament)
    
    return cell
  }
  
}

// MARK: - UITableViewDelegate
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

// MARK: - UISearchBarDelegate
extension ContactsViewController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filterContentForSearchText(searchBar.text!)
  }
  
}
