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
  
  // MARK: - Properties
  var presenter: (ContactsPresenterInput & ContactsPresenterOutput)!
  
  private var disposeBag = DisposeBag()
  
  var contacts: [PersonDataModel] = []
  var filteredContacts: [PersonDataModel] = []
  
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
    initSubscribes()
    loadData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // change tint color
    navigationController?.navigationBar.barTintColor = headerBackgroundColor
  }
  
  func setupNavigationBar() {
    // change back button image (add left offset)
    navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
    
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
  private func initSubscribes() {
    presenter.contactsSubject
      .filter { $0 != nil }
      .map { $0! }
      .subscribe(onNext: { [unowned self] result in
        switch result {
        case .success(let contacts):
          self.contacts = contacts
        case .error(let error):
          print(error)
          DispatchQueue.main.async {
            self.errorView.isHidden = false
          }
        }
        if self.isFiltering() {
          self.presenter.filterContentForSearchText(self.searchBar.text!)
        } else {
          self.refreshFinished()
        }
      }).disposed(by: disposeBag)
    
    presenter.filteredContactsSubject
      .filter { $0 != nil }
      .map { $0! }
      .subscribe(onNext: { [unowned self] result in
        switch result {
        case .success(let contacts):
          self.filteredContacts = contacts
        case .error(let error):
          print(error)
          DispatchQueue.main.async {
            self.errorView.isHidden = false
          }
        }
        self.refreshFinished()
      }).disposed(by: disposeBag)
  }
  
  func loadData() {
    activityIndicator.startAnimating()
    refresh()
  }
  
  @objc func refresh() {
    errorView.isHidden = true
    contactsTableView.isUserInteractionEnabled = false
    
    presenter.loadContacts()
  }
  
  func refreshFinished() {
    refreshControl.endRefreshing()
    activityIndicator.stopAnimating()
    contactsTableView.reloadData()
    contactsTableView.isUserInteractionEnabled = true
  }
  
  // MARK: - Search methods
  func isFiltering() -> Bool {
    return !searchBarIsEmpty()
  }
  
  func searchBarIsEmpty() -> Bool {
    return searchBar.text?.isEmpty ?? true
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
    presenter.filterContentForSearchText(searchBar.text!)
  }
  
}
