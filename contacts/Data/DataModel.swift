//
//  DataModel.swift
//  contacts
//
//  Created by Andrei Coder on 26/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import RealmSwift

class LastUpdateDataModel: Object {
  @objc dynamic var id = ""
  @objc dynamic var time = Date()
  
  override static func primaryKey() -> String? {
    return "id"
  }
}

class EducationPeriodDataModel: Object {
  @objc dynamic var start = ""
  @objc dynamic var end = ""
}

class PersonDataModel: Object {
  @objc dynamic var id = ""
  @objc dynamic var name = ""
  @objc dynamic var phone = ""
  @objc dynamic var height = 0.0
  @objc dynamic var biography = ""
  @objc dynamic var temperament = ""
  @objc dynamic var educationPeriod: EducationPeriodDataModel?
}
