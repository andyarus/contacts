//
//  Utils.swift
//  contacts
//
//  Created by Andrei Coder on 24/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import Foundation

class Utils {
  
  static let shared = Utils()
  
  let dateFormatterIn = ISO8601DateFormatter()
  let dateFormatterOut = DateFormatter()
  
  init() {
    // convert date format
    dateFormatterOut.dateFormat = "dd.MM.yyyy"
  }
  
  func format(phone value: String?) -> String {
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
  
  func format(phoneCall value: String?) -> String {
    guard var phone = value else { return String() }
    //phone = phone.replacingOccurrences(of: "+7", with: "8")
    phone = phone.replacingOccurrences(of: " ", with: "")
    phone = phone.replacingOccurrences(of: "(", with: "")
    phone = phone.replacingOccurrences(of: ")", with: "")
    phone = phone.replacingOccurrences(of: "-", with: "")
    
    return phone
  }
  
  func format(nameSearch value: String?) -> String {
    guard let name = value else { return String() }
    
    return name.lowercased()
  }
  
  func format(phoneSearch value: String?) -> String {
    guard var phone = value else { return String() }
    phone = phone.replacingOccurrences(of: "+7", with: "8")
    phone = phone.replacingOccurrences(of: " ", with: "")
    phone = phone.replacingOccurrences(of: "(", with: "")
    phone = phone.replacingOccurrences(of: ")", with: "")
    phone = phone.replacingOccurrences(of: "-", with: "")
    
    return phone
  }
  
  func format(temperament value: String?) -> String {
    guard var temperament = value else { return String() }
    temperament = temperament.prefix(1).capitalized + temperament.dropFirst()
    
    return temperament
  }
  
  func format(date value: String?) -> String {
    guard let dateString = value,
      let date = dateFormatterIn.date(from: dateString) else { return String() }
    
    return dateFormatterOut.string(from: date)
  }
  
  func protectEducationPeriod(byCheck person: PersonDataModel) -> EducationPeriodDataModel? {
    guard let educationPeriod = person.educationPeriod,
      let startDate = dateFormatterIn.date(from: educationPeriod.start),
      let endDate = dateFormatterIn.date(from: educationPeriod.end) else { return nil }
    
    if startDate > endDate {
      print("\(person.name) id:\(person.id) have wrong education period start:\(startDate) - end:\(endDate) ")
      // TODO send notification to telegram bot, email, firebase or something like this
    }
    
    return educationPeriod
  }
  
  func protectEducationPeriod(bySwap person: PersonDataModel) -> EducationPeriodDataModel? {
    guard let educationPeriod = person.educationPeriod,
      let startDate = dateFormatterIn.date(from: educationPeriod.start),
      let endDate = dateFormatterIn.date(from: educationPeriod.end) else { return nil }

    if startDate > endDate {
      let educationPeriodNew = EducationPeriodDataModel()
      educationPeriodNew.start = educationPeriod.end
      educationPeriodNew.end = educationPeriod.start
      return educationPeriodNew
    }
    
    return educationPeriod
  }
  
}
