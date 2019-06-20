//
//  Person.swift
//  contacts
//
//  Created by Andrei Coder on 21/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

struct EducationPeriod: Decodable {
  let start: String
  let end: String
  
  enum CodingKeys: String, CodingKey {
    case start = "start"
    case end = "end"
  }
}

struct PersonJson: Decodable {
  let id: Int?
  let name: String?
  let phone: String?
  let height: Float?
  let biography: String?
  let temperament: String?
  let educationPeriod: EducationPeriod?
  
  enum CodingKeys: String, CodingKey {
    case id              = "id"
    case name            = "name"
    case phone           = "phone"
    case height          = "height"
    case biography       = "biograpy"
    case temperament     = "temperament"
    case educationPeriod = "educationPeriod"
  }
}

enum Temperament: String {
  case melancholic
  case phlegmatic
  case sanguine
  case choleric
}

struct Person {
  let id: Int?
  let name: String?
  let phone: String?
  let height: Float?
  let biography: String?
  let temperament: Temperament?
  let educationPeriod: EducationPeriod?
}
