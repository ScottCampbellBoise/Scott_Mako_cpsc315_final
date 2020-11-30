//
//  ViewController.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 11/27/20.
//

import UIKit
import CoreData

class VocabTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    // Define the data source for the Table View
    var words = [Word]()
    
    // We need a reference to the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Loaded Vocab View")
        
        // Do any additional setup after loading the view.
        loadWords()
        
        print("MOVE THE SPEECH SYNTH CODE TO EVENTUAL HOME SCREEN!")
        SpeechSynthesizer.languageCode = LanguageCode.germanDE
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Vocab Table View Controller will appear")
        
        loadWords()
        tableView.reloadData()
    }
    
    func loadTestWords() {
        let word1 = Word(context: self.context)
        word1.englishWord = "Good Bye"
        word1.foriegnWord = "Tschuss"
        word1.markedForReview = false
        word1.mnemonic = nil
        word1.timesMissed = 0
        word1.timesCorrect = 0
        
        self.words.append(word1)
        self.saveWords()
        
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
            let newWord = Word(context: self.context)
            // Add the rest of the fields!
            newWord.englishWord = text
            
            self.words.append(newWord)
            self.saveWords()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
         
    }
    
    // MARK: - Search Bar Delegate Method(s)
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     
    }
    
    func performSearch(searchBar: UISearchBar) {
        if let input = searchBar.text {
            
        }
    }
    
    // MARK: Core Data Methods
    
    func saveWords() {
        // We need to save the context
        do {
            try context.save()
        } catch {
            print("Error saving the Words: \(error)")
        }
        tableView.reloadData()
    }
    
    // READ of CRUD
    func loadWords() {
        // we need to "request" the categories from the database (using the persistent container's context
        let request: NSFetchRequest<Word> = Word.fetchRequest()
  
        do {
            words = try context.fetch(request)
        }
        catch {
            print("Error loading words \(error)")
        }
        tableView.reloadData()
    }

}

