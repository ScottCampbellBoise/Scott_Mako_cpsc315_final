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
    
    override func viewWillAppear(_ animated: Bool) {
        print("Study Set View Will Appear")
        
        tableView.reloadData()
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
        cell.detailTextLabel?.text = "\(studyset.getNumWords()) Words"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete study set and vocabs within it...
            let wordsInSetOptional = DatabaseManager.fetchWords(fromStudysets: [studysets[indexPath.row]])
            if let wordsInSet = wordsInSetOptional {
                for word in wordsInSet {
                    word.removeFromStudysets(studysets[indexPath.row])
                }
            }
            // Remove the study set itself from the database
            DatabaseManager.context.delete(studysets[indexPath.row])
            studysets.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            DatabaseManager.saveContext()
        }
    }
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add a new study set", message: "", preferredStyle: .alert)
        
        alert.addTextField { (studysetTextField) in
            studysetTextField.placeholder = "Studyset name"
            alertTextField = studysetTextField
        }
        
        alert.addAction(UIAlertAction(title: "Create", style: .default) { (alertAction) in
            let text = alertTextField.text!
            // This is the CREATE in CRUD
            // Make a Category using Context
            let newStudyset = StudySet(context: DatabaseManager.context)
            // Add the rest of the fields!
            newStudyset.name = text
            
            self.studysets.append(newStudyset)
            DatabaseManager.saveStudySets()
            self.tableView.reloadData()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            print("Pressed Cancel")
        })
        
        //alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "StudysetDetailSegue" {
                if let detailVC = segue.destination as? StudysetDetailTableViewController {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        let studyset = studysets[indexPath.row]
                        detailVC.studysetOptional = studyset
                    }
                }
            }
        }
    }
    
    
    
}
