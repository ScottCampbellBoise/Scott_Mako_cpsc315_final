//
//  ViewController.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 11/27/20.
//

import UIKit

class VocabTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    
    // Define the data source for the Table View
    var words = [Word]()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Loaded Vocab View")
        
        // Do any additional setup after loading the view.
        let wordsOptional = DatabaseManager.loadWords()
        if let unwrappedWords = wordsOptional { words = unwrappedWords }
        
        
        /*if let newWords = LoadInWords.loadWords() {
            print("Added new words")
            words.append(contentsOf: newWords)
            DatabaseManager.saveWords()
            tableView.reloadData()
        } else {
            print("Couldn't add new words")
        }*/
        
        
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsDirectoryURL)
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Vocab Table View Controller will appear")
        
        let wordsOptional = DatabaseManager.loadWords()
        if let unwrappedWords = wordsOptional { words = unwrappedWords }
        tableView.reloadData()
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "practiceSegue" {
                if let practiceVC = segue.destination as? SpeechPracticeViewController {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        let word = words[indexPath.row]
                        practiceVC.wordOptional = word
                    }
                }
            }
        }
    }
    
    // MARK: TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return words.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VocabCell", for: indexPath) as! VocabTableViewCell
        let word = words[indexPath.row]
        cell.update(with: word)
        
        return cell
    }
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        print("UPDATE THE ADD ITEM METHOD!!!")
        
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add a new word", message: "", preferredStyle: .alert)
        
        alert.addTextField { (englishtextField) in
            englishtextField.placeholder = "English Word"
            alertTextField = englishtextField
        }
        
        let action = UIAlertAction(title: "Create", style: .default) { (alertAction) in
            let text = alertTextField.text!
            // This is the CREATE in CRUD
            // Make a Category using Context
            let newWord = Word(context: DatabaseManager.context)
            // Add the rest of the fields!
            newWord.englishWord = text
            
            self.words.append(newWord)
            DatabaseManager.saveWords()
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
         
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

