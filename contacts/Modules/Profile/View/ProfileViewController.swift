//
//  ProfileViewController.swift
//  contacts
//
//  Created by Andrei Coder on 23/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  
  // MARK: - Properties
  var person: Person! = nil
  
  let barTintColor = UIColor(red: 250/255, green: 249/255, blue: 255/255, alpha: 1)
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var educationPeriodLabel: UILabel!
  @IBOutlet weak var temperamentLabel: UILabel!
  @IBOutlet weak var phoneButton: UIButton!
  @IBOutlet weak var biographyTextView: UITextView!
  
  // MARK: - View Setup
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // change tint color
    navigationController?.navigationBar.barTintColor = barTintColor
  }
  
  func setup() {
    let phone = Utils.shared.format(phone: person.phone)
    let educationPeriod = Utils.shared.protectEducationPeriod(byCheck: person)
    //let educationPeriod = Utils.shared.protectEducationPeriod(bySwap: person)
    let startDate = Utils.shared.format(date: educationPeriod?.start)
    let endDate = Utils.shared.format(date: educationPeriod?.end)
    
    nameLabel.text = person.name
    educationPeriodLabel.text = "\(startDate) \u{2013} \(endDate)" // \u{2013} == –
    temperamentLabel.text = Utils.shared.format(temperament: person.temperament?.rawValue)
    phoneButton.setTitle(phone, for: .normal)
    biographyTextView.text = person.biography
  }
  
  // MARK: - Actions
  @IBAction func phoneButtonClicked(_ sender: UIButton) {
    let phone = Utils.shared.format(phoneCall: sender.title(for: .normal)?.trimmingCharacters(in: .whitespacesAndNewlines))
    guard !phone.isEmpty else { return }
    if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
  }
  
}
