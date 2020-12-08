//
//  StudySetViewController.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 12/1/20.
//

import UIKit

class StudySetTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    // Define the data source for the Table View
    var studysets = [StudySet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Loaded Study Set View")
        
        // Do any additional setup after loading the view.
        let studysetsOptional = DatabaseManager.loadStudySets()
        if let unwrappedSets = studysetsOptional {
            studysets = unwrappedSets
        }
    }

    // MARK: TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return studysets.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudySetCell", for: indexPath)
        let studyset = studysets[indexPath.row]
        cell.textLabel?.text = studyset.name
        cell.detailTextLabel?.text = "Add num of words in set!"
        // TODO: Add the number of elements as the subtitle!
        
        return cell
    }
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add a new study set", message: "", preferredStyle: .alert)
        
        alert.addTextField { (studysetTextField) in
            studysetTextField.placeholder = "Studyset name"
            alertTextField = studysetTextField
        }
        
        let action = UIAlertAction(title: "Create", style: .default) { (alertAction) in
            let text = alertTextField.text!
            // This is the CREATE in CRUD
            // Make a Category using Context
            let newStudyset = StudySet(context: DatabaseManager.context)
            // Add the rest of the fields!
            newStudyset.name = text
            
            self.studysets.append(newStudyset)
            DatabaseManager.saveStudySets()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        print("NEED TO ADD FUNCTIONALITY TO ADD WORDS TO STUDYSET!!")
    }
    
}
