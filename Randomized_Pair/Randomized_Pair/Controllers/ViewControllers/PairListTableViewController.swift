//
//  PairListTableViewController.swift
//  Randomized_Pair
//
//  Created by James Chun on 5/21/21.
//

import UIKit

class PairListTableViewController: UITableViewController {

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PairController.sharedInstance.loadFromPersistenceStore()
    }
    
    //MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentAlertController()
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        PersonController.shufflePairs()
        tableView.reloadData()
    }
    
    //MARK: - Functions
    
    func presentAlertController() {
        
        let alert = UIAlertController(title: "Add Person", message: "Add someone new to the list", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Full Name"
            textField.autocapitalizationType = .words
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let name = alert.textFields?.first?.text else { return }
                  
            let lastGroup = PairController.sharedInstance.pairs.last
            
            if let lastGroup = lastGroup {
                if lastGroup.people.count < PairController.sharedInstance.peoplePerGroup {
                    PersonController.createPersonWith(name: name, pair: lastGroup)
                } else {
                    PairController.sharedInstance.createPair()
                    guard let lastGroup = PairController.sharedInstance.pairs.last else { return }
                    PersonController.createPersonWith(name: name, pair: lastGroup)
                }
            } else {
                PairController.sharedInstance.createPair()
                guard let lastGroup = PairController.sharedInstance.pairs.last else { return }
                PersonController.createPersonWith(name: name, pair: lastGroup)
            }
            
            self.tableView.reloadData()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)
    }//end of func
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return PairController.sharedInstance.pairs.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group \(section+1)"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        return PairController.sharedInstance.pairs[section].people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)

        let person = PairController.sharedInstance.pairs[indexPath.section].people[indexPath.row]
        cell.textLabel?.text = person.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let pair = PairController.sharedInstance.pairs[indexPath.section]
            let person = pair.people[indexPath.row]
            PersonController.deletePerson(person: person, pair: pair)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //JCHUN - Add update function

}//End of class
