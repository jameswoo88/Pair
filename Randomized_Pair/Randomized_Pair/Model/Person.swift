//
//  Person.swift
//  Randomized_Pair
//
//  Created by James Chun on 5/21/21.
//

import Foundation

class Person: Codable {
    
    var name: String
    let uuidString: String
    
    init(name: String, uuidString: String = UUID().uuidString) {
        self.name = name
        self.uuidString = uuidString
    }
    
}//End of class

extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.uuidString == rhs.uuidString
    }
}
