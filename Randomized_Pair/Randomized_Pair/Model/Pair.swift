//
//  Pair.swift
//  Randomized_Pair
//
//  Created by James Chun on 5/21/21.
//

import Foundation

class Pair: Codable {
    var people: [Person]
    
    init(people: [Person] = []) {
        self.people = people
    }
    
}//End of class

extension Pair: Equatable {
    static func == (lhs: Pair, rhs: Pair) -> Bool {
        return lhs.people == rhs.people
    }
    
}//End of extension
