//
//  EmployeeResponseModel.swift
//  TestTableViewFromJsonApp
//
//  Created by Mikhail Malaschenko on 16.06.23.
//

import CoreData

struct EmployeeResponseModel: Codable {
    let data: [EmployeeModel]?
}

struct EmployeeModel: Codable, CoreDataConvertible {
    let id: Int?
    let name: String?
    let gender: Gender?
    
    init?(from entity: Employee) {
        self.id = entity.id.flatMap { Int($0) }
        self.name = entity.name
        self.gender = Gender(rawValue: entity.gender ?? "")
    }
    
    func toEntity(in context: NSManagedObjectContext) -> Employee {
        let employeeEntity = Employee(context: context)
        employeeEntity.id = id.flatMap { String($0) }
        employeeEntity.name = name
        employeeEntity.gender = gender?.rawValue
        return employeeEntity
    }
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
}
