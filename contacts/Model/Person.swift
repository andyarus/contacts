//
//  Person.swift
//  contacts
//
//  Created by Andrei Coder on 21/06/2019.
//  Copyright © 2019 Andrei Coder. All rights reserved.
//

import Foundation

struct EducationPeriod {
  let start: String
  let end: String
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
  let height: Float?
  let biograpy: String?
  let temperament: Temperament?
  let educationPeriod: EducationPeriod?
}

//id (string) — ID контакта
//name (string) — Имя человека
//height (float) — Рост человека
//biography (string) — Биография человека
//temperament (enum) — Темперамент человека (melancholic, phlegmatic, sanguine, choleric)
//educationPeriod (object) — Период прохождения учебы. Состоит из дат start и end.
