//
//  SelectWordsTableViewController.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 12/9/20.
//

import UIKit

class StudysetDetailTableViewController: UITableViewController, UISearchBarDelegate {

    // SelectWordCell
    // StudysetDetailSegue
        
    // Define the data source for the Table View
    var words = [Word]()
    var wordWasSelected = [Bool]()
    var studysetOptional: StudySet? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wordsOptional = DatabaseManager.loadWords()
        if let unwrappedWords = wordsOptional {
            words = unwrappedWords
            wordWasSelected = [Bool](repeating: false, count: words.count)
        }
        
        // Load in all the words already corresponding to this
        if let studyset = studysetOptional {
            let wordsOptional = DatabaseManager.fetchWords(fromStudysets: [studyset])
            if let unwrappedWords = wordsOptional {
                print("Found \(unwrappedWords.count) words in studyset \(studyset.name)")
                // Now, find those words and pre-select them
                let preselectedWords = DatabaseManager.fetchWords(fromStudysets: [studyset]) ?? [Word]()
                // Go through the words and find its spot in the master array
                for theWord in preselectedWords {
                    let index = getIndexOfWord(fromWord: theWord)!
                    wordWasSelected[index] = true
                }
            } else { print("Could not find any words for the studyset") }
        } else { print("No studyset specified!") }
        
        tableView.reloadData()
    }
    
    func getIndexOfWord(fromWord: Word) -> Int? {
        for kk in 0..<words.count {
            let word = words[kk]
            if (word.englishWord == fromWord.englishWord) && (word.foriegnWord == fromWord.foriegnWord) {
                return kk
            }
        }
        return nil
    }

    // MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return words.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectWordCell", for: indexPath) as! SelectableWordCell
        let word = words[indexPath.row]
        cell.update(with: word)
        if wordWasSelected[indexPath.row] {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Toggle the checkmark on and off
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                wordWasSelected[indexPath.row] = false
                // Attempting to remove the word from the studyset
                if let set = studysetOptional {
                    words[indexPath.row].removeWordFromStudySet(studyset: set)
                    DatabaseManager.saveContext()
                }
            } else {
                cell.accessoryType = .checkmark
                wordWasSelected[indexPath.row] = true
                // Attempting to add the word to the studyset
                if let set = studysetOptional {
                    words[indexPath.row].addWordToStudySet(studyset: set)
                    DatabaseManager.saveContext()
                }
            }
        }
    }
    
    // MARK: - Search Bar Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            performSearch(searchBar: searchBar)
        } else {
            // Search bar is empty
            searchBar.resignFirstResponder()
            
            let wordsOptional = DatabaseManager.loadWords()
            if let unwrappedWords = wordsOptional { words = unwrappedWords }
            tableView.reloadData()
        }
    }
    
    func performSearch(searchBar: UISearchBar) {
        if let text = searchBar.text {
            // we need a predicate to filter items by text
            let predicate = NSPredicate(format: "englishWord CONTAINS[cd] %@ OR foriegnWord CONTAINS[cd] %@", text, text)
    
            let wordsOptional = DatabaseManager.loadWords(withPredicate: predicate)
            if let unwrappedWords = wordsOptional { words = unwrappedWords }
            tableView.reloadData()
        }
    }
}
