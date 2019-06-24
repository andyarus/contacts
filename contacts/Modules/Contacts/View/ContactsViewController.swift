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
  var errorView: UIView!
  
  var networkErrorsCount = 0
  var testErrorView = false // change for testing loading error notification
  
  @IBOutlet var contactsTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // hide empty separators
    contactsTableView.tableFooterView = UIView()
    
    setupNavigationBar()
    initSubviews()
    loadData()
  }
  
  func setupNavigationBar() {
    // move title label to the left
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 17)
    label.text = "Contacts"
    navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
    
    // remove "Back"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
  
  func initSubviews() {
    // activity indicator subview
    
    // refresh control
    refreshControl = UIRefreshControl()
    refreshControl.tintColor = .lightGray
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    contactsTableView.addSubview(refreshControl)
    
    // error subview
    errorView = UIView()
    guard let nc = navigationController else { return }
    
    let errorViewOffset: CGFloat = 33
    let errorViewWidth: CGFloat = UIScreen.main.bounds.width-errorViewOffset*2
    let errorViewHeight: CGFloat = 55
    errorView.frame = CGRect(x: 0, y: 0, width: errorViewWidth, height: errorViewHeight)
    errorView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    errorView.layer.cornerRadius = 10
    
    let label = UILabel(frame: errorView.frame)
    label.text = "Нет подключения к сети"
    label.font = UIFont.boldSystemFont(ofSize: 17)
    label.textColor = .white
    label.textAlignment = .center
    errorView.addSubview(label)
    //label.centerXAnchor.constraint(equalTo: errorView.centerXAnchor).isActive = true
    //label.centerYAnchor.constraint(equalTo: errorView.centerYAnchor).isActive = true
    
    nc.view.addSubview(errorView)
    
    errorView.translatesAutoresizingMaskIntoConstraints = false
    let bottomConstraint = errorView.bottomAnchor.constraint(equalTo: navigationController!.view.bottomAnchor)
    bottomConstraint.constant = -35
    bottomConstraint.isActive = true
    errorView.centerXAnchor.constraint(equalTo: nc.view.centerXAnchor).isActive = true
    errorView.widthAnchor.constraint(equalToConstant: errorViewWidth).isActive = true
    errorView.heightAnchor.constraint(equalToConstant: errorViewHeight).isActive = true
    
    label.frame = errorView.frame
    errorView.isHidden = true
  }
  
  func loadData() {
    //refreshControl.beginRefreshing()
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
                
                self.refreshControl.endRefreshing()
                self.contactsTableView.reloadData()
                self.contactsTableView.isUserInteractionEnabled = true
                
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
    errorView.isHidden = false
    refreshControl.endRefreshing()
    contactsTableView.reloadData()
    contactsTableView.isUserInteractionEnabled = true
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
  }
  
}
