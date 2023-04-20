//
//  dataModel.swift
//  dataModel
//
//  Created by Nibras Fitri Zuhra on 19/04/23.
//

import Foundation

class DataModel: Encodable, Decodable, ObservableObject {
    @Published var id: String
    @Published var name: String
    @Published var age: Int
    @Published var gender: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case age
        case gender
    }
    
    init(id: String = UUID().uuidString, name: String, age: Int, gender: String) {
        self.id = id
        self.name = name
        self.age = age
        self.gender = gender
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        age = try container.decode(Int.self, forKey: .age)
        gender = try container.decode(String.self, forKey: .gender)
    }
    
    func encode(to encoder: Encoder) throws {
        var container =  encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(gender, forKey: .gender)
    }
}
