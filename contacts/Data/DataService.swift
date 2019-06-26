//
//  DataService.swift
//  contacts
//
//  Created by Andrei Coder on 26/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import RealmSwift

class DataService {
  private let realm = try! Realm()
  
  private let lastUpdateTimeLimit: TimeInterval = 60 // seconds
  
  func getContacts() -> Results<PersonDataModel> {
    return realm.objects(PersonDataModel.self)
    // TODO add processing possible error
  }
  
  func update(_ contacts: [Person]) -> Results<PersonDataModel> {
    try! realm.write() {
      // delete previous contacts
      realm.delete(realm.objects(PersonDataModel.self))
      
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
        
        realm.add(newPerson)
      }
      
      // save last update time
      setLastUpdate()
    }
    
    return realm.objects(PersonDataModel.self)
  }
  
  func isUpdateTimeLimitExceeded() -> Bool {
    
    //print("left:\(Date().timeIntervalSince1970 - (realm.objects(LastUpdateDataModel.self).first?.time.timeIntervalSince1970)!)")
    
    if let lastUpdate = realm.objects(LastUpdateDataModel.self).first,
      Date().timeIntervalSince1970 - lastUpdate.time.timeIntervalSince1970 < lastUpdateTimeLimit {
      return false
    }
    
    return true
  }
  
  private func setLastUpdate() {
    let lastUpdate = LastUpdateDataModel()
    lastUpdate.time = Date()
    realm.add(lastUpdate, update: true)
  }
  
}
