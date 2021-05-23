//
//  PairListTableViewController.swift
//  Randomized_Pair
//
//  Created by James Chun on 5/21/21.
//

import UIKit

class PairListTableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var picker: UIPickerView!
    
    //MARK: - Properties
    let pickerData: [String] = ["2", "3", "4", "5", "6", "7", "8", "9"]
    //static var numberOfPeople: Int?

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        
        PairController.sharedInstance.loadFromPersistenceStore()
        updatePickerView()
    }
    
    //MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentAlertController(title: "Add Person", message: "Add someone new to the list")
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        PersonController.shufflePairs()
        tableView.reloadData()
    }
    
    //MARK: - Functions
    func updatePickerView() {
        let number = PairController.sharedInstance.pairs.isEmpty ? 2 : PairController.sharedInstance.pairs[0].people.count
        
        PairController.sharedInstance.peoplePerGroup = number
        picker.selectRow(number-2, inComponent: 0, animated: true)
    }
    
    func presentAlertController(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let indexPath = tableView.indexPathForSelectedRow
        
        alert.addTextField { textField in
            textField.placeholder = "Full Name"
            textField.autocapitalizationType = .words
            
            if let indexPath = indexPath {
                textField.text = PairController.sharedInstance.pairs[indexPath.section].people[indexPath.row].name
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let name = alert.textFields?.first?.text else { return }
            
            let lastGroup = PairController.sharedInstance.pairs.last
            
            if let indexPath = indexPath {
                let pair = PairController.sharedInstance.pairs[indexPath.section]
                let row = indexPath.row
                PersonController.update(pair: pair, name: name, row: row)
            } else {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentAlertController(title: "Edit Person", message: "Edit the person's name")
    }

}//End of class

extension PairListTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let number = Int(pickerData[row])!
        PairController.sharedInstance.peoplePerGroup = number
        updateTableView()
    }
    
    //MARK: - Functions
    func updateTableView() {
        let allPeople: [Person] = {
            var people: [Person] = []
            for pair in PairController.sharedInstance.pairs {
                for person in pair.people {
                    people.append(person)
                }
            }
            return people
        }()
        
        PairController.sharedInstance.pairs.removeAll()

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
        tableView.reloadData()
    }
    
}//End of extension
