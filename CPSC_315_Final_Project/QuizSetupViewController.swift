//
//  QuizSetupViewController.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 12/1/20.
//

import UIKit
import CoreData

class QuizSetupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var useAllWordsButton: UIButton!
    @IBOutlet var goButton: UIButton!
    
    // Define the data source for the Table View
    var studysets = [StudySet]()
    var studysetWasSelected = [Bool]()
    
    // MARK: App Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Loaded Quiz Prep View")
        
        let studysetsOptional = DatabaseManager.loadStudySets()
        if let unwrappedSets = studysetsOptional { studysets = unwrappedSets
            // Set the selected bool array to all false
            studysetWasSelected = [Bool](repeating: false, count: studysets.count)
        } else {
            print("Could not load/find any studysets for Quiz Setup...")
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Quiz Prep View Controller will appear")
        let studysetsOptional = DatabaseManager.loadStudySets()
        if let unwrappedSets = studysetsOptional { studysets = unwrappedSets
            // Set the selected bool array to all false
            studysetWasSelected = [Bool](repeating: false, count: studysets.count)
        }
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizPrepCell", for: indexPath)
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
                studysetWasSelected[indexPath.row] = false
            } else {
                cell.accessoryType = .checkmark
                studysetWasSelected[indexPath.row] = true
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if let quizVC = segue.destination as? QuizViewController {
                if identifier == "GoSegue" {
                    // Find all the selected studysets and extract out the words
                    quizVC.flashcardSetOptional = getSelectedWords()
                } else {
                    // Send all the words to the flashcard controller
                    quizVC.flashcardSetOptional = DatabaseManager.loadWords()
                }
            }
        }
    }
    
    func getSelectedWords() -> [Word] {
        // First, get an array of all studysets cells that were selected
        var selectedSets = [StudySet]()
        print("Selected sets to use for quiz: ")
        for kk in 0..<studysetWasSelected.count {
            if studysetWasSelected[kk] {
                selectedSets.append(studysets[kk])
                print("    \(studysets[kk].name)")

            }
        }
        
        if selectedSets.count < 1 {
            print("NO STUDY SETS SELECTED, USING ALL WORDS")
            return DatabaseManager.loadWords() ?? [Word]()
        }
        
        let resultsOptional = DatabaseManager.fetchWords(fromStudysets: selectedSets)
        // Try to unwrap the results
        if let results = resultsOptional {
            print("Found \(results.count) Words to use in quiz")
            return results
        } else {
            print("Got no results back from the quiz setup request")
            return DatabaseManager.loadWords() ?? [Word]()
        }
    }

}
