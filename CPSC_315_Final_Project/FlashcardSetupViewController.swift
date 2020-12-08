//
//  FlashcardSetupViewController.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 12/1/20.
//

import UIKit
import CoreData

class FlashcardSetupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var useAllWordsButton: UIButton!
    @IBOutlet var goButton: UIButton!
    
    // Define the data source for the Table View
    var studysets = [StudySet]()
    
    // We need a reference to the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Loaded Flashcard Prep View")
        
        // Do any additional setup after loading the view.
        let studysetsOptional = DatabaseManager.loadStudySets()
        if let unwrappedSets = studysetsOptional { studysets = unwrappedSets }
    }

    // MARK: TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return studysets.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlashcardPrepCell", for: indexPath)
        let studyset = studysets[indexPath.row]
        cell.textLabel?.text = studyset.name
        cell.detailTextLabel?.text = "Add num of words in set!"
        cell.accessoryType = UITableViewCell.AccessoryType.none

        // TODO: Add the number of elements as the subtitle!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Toggle the checkmark on and off
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if let flashcardVC = segue.destination as? FlashcardViewController {
                if identifier == "GoSegue" {
                    // Find all the selected studysets and extract out the words
                    
                } else {
                    // Send all the words to the flashcard controller
                    flashcardVC.flashcardSetOptional = DatabaseManager.loadWords()
                }
            }
        }
    }

}
