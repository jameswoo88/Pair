//
//  PersonController.swift
//  Randomized_Pair
//
//  Created by James Chun on 5/21/21.
//

import Foundation

class PersonController {
    //MARK: - Functions
    //CRUD
    
    static func createPersonWith(name: String, pair: Pair) {
        let newPerson = Person(name: name)
        PairController.sharedInstance.addPersonTo(pair: pair, person: newPerson)
    }
    
    static func deletePerson(person: Person, pair: Pair) {
        PairController.sharedInstance.removePersonFrom(pair: pair, person: person)
    }
    
    static func update(pair: Pair, name: String, row: Int) {
        PairController.sharedInstance.update(pair: pair, name: name, row: row)
    }
    
    static func shufflePairs() {
        var allPeople: [Person] = {
            var people: [Person] = []
            for pair in PairController.sharedInstance.pairs {
                for person in pair.people {
                    people.append(person)
                }
            }
            return people
        }()
        
        PairController.sharedInstance.pairs.removeAll()
        allPeople.shuffle()

        var peopleContainer: [Person] = []
        var newPair = Pair()
        
        for person in allPeople {
            peopleContainer.append(person)
            
            if peopleContainer.count == PairController.sharedInstance.peoplePerGroup {
                newPair = Pair(people: peopleContainer)
                PairController.sharedInstance.pairs.append(newPair)
                
                peopleContainer = []
                newPair = Pair()
            } else if allPeople.count % PairController.sharedInstance.peoplePerGroup != 0 && PairController.sharedInstance.pairs.count >= allPeople.count / PairController.sharedInstance.peoplePerGroup {
                
                if person == allPeople.last {
                    newPair = Pair(people: peopleContainer)
                    
                    PairController.sharedInstance.pairs.append(newPair)
                    
                    peopleContainer = []
                    newPair = Pair()                    
                }
            }
        }
            
        PairController.sharedInstance.saveToPersistenceStore()
    }//end of func
    
}//End of class
