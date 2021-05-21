//
//  PersonController.swift
//  Randomized_Pair
//
//  Created by James Chun on 5/21/21.
//

import Foundation

class PersonController {
    //MARK: - Properties
    private static var people: [Person] = []
    
    //MARK: - Functions
    //CRUD
    
    static func createPersonWith(name: String, pair: Pair) {
        let newPerson = Person(name: name)
        people.append(newPerson)
        PairController.sharedInstance.addPersonTo(pair: pair, person: newPerson)
    }
    
    static func deletePerson(person: Person, pair: Pair) {
        guard let index = people.firstIndex(of: person) else { return }
        people.remove(at: index)
        PairController.sharedInstance.removePersonFrom(pair: pair, person: person)
    }
    
    static func update(person: Person, name: String) {
        person.name = name
    }
    
    static func shufflePairs() {
        PairController.sharedInstance.pairs.removeAll()
        people.shuffle()

        var peopleContainer: [Person] = []
        var newPair = Pair()
        
        for person in people {
            peopleContainer.append(person)
            
            if peopleContainer.count == PairController.sharedInstance.peoplePerGroup {
                newPair = Pair(people: peopleContainer)
                PairController.sharedInstance.pairs.append(newPair)
                
                peopleContainer = []
                newPair = Pair()
            } else if people.count % PairController.sharedInstance.peoplePerGroup != 0 && PairController.sharedInstance.pairs.count == people.count / PairController.sharedInstance.peoplePerGroup {
                newPair = Pair(people: peopleContainer)
                PairController.sharedInstance.pairs.append(newPair)
                
                peopleContainer = []
                newPair = Pair()
            }
        }
            
        PairController.sharedInstance.saveToPersistenceStore()
    }//end of func
    
}//End of class
