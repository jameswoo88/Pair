//
//  PairController.swift
//  Randomized_Pair
//
//  Created by James Chun on 5/21/21.
//

import Foundation

class PairController {
    //MARK: - Properties
    //shared
    static let sharedInstance = PairController()
    
    //SOT
    var pairs: [Pair] = []
    var peoplePerGroup: Int = 2
    
    //MARK: - Functions
    //CRUD
    func createPair() {
        let pair = Pair()
        pairs.append(pair)
        saveToPersistenceStore()
    }
    
    func delete(pair: Pair) {
        guard let index = pairs.firstIndex(of: pair) else { return }
        pairs.remove(at: index)
        saveToPersistenceStore()
    }
    
    func update(pair: Pair, name: String, row: Int) {
        pair.people[row].name = name
        saveToPersistenceStore()
    }
    
    func addPersonTo(pair: Pair, person: Person) {
        pair.people.append(person)
        saveToPersistenceStore()
    }
    
    func removePersonFrom(pair: Pair, person: Person) {
        guard let index = pair.people.firstIndex(of: person) else { return }
        pair.people.remove(at: index)
        saveToPersistenceStore()
    }
    
    
    //MARK: - Persistence
    func createPersistenceStore() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = url[0].appendingPathComponent("Randomized_Pair.json")
        
        return fileURL
    }
    
    func saveToPersistenceStore() {
        do {
            let data = try JSONEncoder().encode(pairs)
            try data.write(to: createPersistenceStore())
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    func loadFromPersistenceStore() {
        do {
            let data = try Data(contentsOf: createPersistenceStore())
            pairs = try JSONDecoder().decode([Pair].self, from: data)
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    
}//End of class
