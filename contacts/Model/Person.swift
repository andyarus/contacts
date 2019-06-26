//
//  Person.swift
//  contacts
//
//  Created by Andrei Coder on 21/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

enum Temperament: String, Codable {
  case melancholic
  case phlegmatic
  case sanguine
  case choleric
}

struct EducationPeriod: Codable {
  let start: String?
  let end: String?
}

struct Person: Codable {
  let id: String?
  let name: String?
  let phone: String?
  let height: Float?
  let biography: String?
  let temperament: Temperament?
  let educationPeriod: EducationPeriod?
}
