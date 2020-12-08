//
//  ViewController.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 11/27/20.
//

import UIKit
import CoreData

class VocabTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

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
        
        //loadTestWords()
        
        testCoreDataRelations()
        
        print("MOVE THE SPEECH SYNTH CODE TO EVENTUAL HOME SCREEN!")
        SpeechSynthesizer.languageCode = LanguageCode.germanDE
        
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsDirectoryURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Vocab Table View Controller will appear")
        
        loadWords()
        tableView.reloadData()
    }
    
    func loadTestWords() {
        // Define the master studyset
        let masterSet = getMasterStudySet()
        
        if masterSet == nil {
            print("Could not find master set!!!")
            return
        }
        
        var word1 = Word(context: self.context)
        word1.englishWord = "Good Morning"
        word1.foriegnWord = "Guten Morgen"
        word1.markedForReview = false
        word1.mnemonic = nil
        word1.timesMissed = 0
        word1.timesCorrect = 0
        word1.addWordToStudySet(studyset: masterSet!)
        self.words.append(word1)
        
        word1 = Word(context: self.context)
        word1.englishWord = "Good Afternoon"
        word1.foriegnWord = "Guten Tag"
        word1.markedForReview = false
        word1.mnemonic = nil
        word1.timesMissed = 0
        word1.timesCorrect = 0
        word1.addWordToStudySet(studyset: masterSet!)
        self.words.append(word1)
        
        word1 = Word(context: self.context)
        word1.englishWord = "Good Evening"
        word1.foriegnWord = "Guten Abend"
        word1.markedForReview = false
        word1.mnemonic = nil
        word1.timesMissed = 0
        word1.timesCorrect = 0
        word1.addWordToStudySet(studyset: masterSet!)
        self.words.append(word1)
        
        word1 = Word(context: self.context)
        word1.englishWord = "Good Night"
        word1.foriegnWord = "Gute Nacht"
        word1.markedForReview = false
        word1.mnemonic = nil
        word1.timesMissed = 0
        word1.timesCorrect = 0
        word1.addWordToStudySet(studyset: masterSet!)
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
    
    // MARK: - Search Bar Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            performSearch(searchBar: searchBar)
        } else {
            // Search bar is empty
            searchBar.resignFirstResponder()
            loadWords()
        }
    }
    
    func performSearch(searchBar: UISearchBar) {
        if let text = searchBar.text {
            // we need a predicate to filter items by text
            let predicate = NSPredicate(format: "englishWord CONTAINS[cd] %@ OR foriegnWord CONTAINS[cd] %@", text, text)
    
            loadWords(withPredicate: predicate)
        }
    }
    
    // MARK: Core Data Methods
    
    func testCoreDataRelations() {
        print("Testing Core Data Relations")
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        let studysetPredicate = NSPredicate(format: "ANY studysets.name =[cd] %@", "Master")
        request.predicate = studysetPredicate
        
        do {
            let results: [Word] = try context.fetch(request)
            print("Found \(results.count) Results!")
            for word in results {
                print("    \(word.foriegnWord) - \(word.englishWord)")
            }
        }
        catch {
            print("Relational Test Failed! \(error)")
           
        }
    }
    
    func getMasterStudySet() -> StudySet? {
        let request: NSFetchRequest<StudySet> = StudySet.fetchRequest()
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", "Master")
        request.predicate = predicate
        
        do {
            let masterSets: [StudySet] = try context.fetch(request)
            return masterSets[0]
        }
        catch {
            print("Error loading words \(error)")
            return nil
        }
    }
    
    
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
    func loadWords(withPredicate predicate: NSPredicate? = nil) {
        // we need to "request" the categories from the database (using the persistent container's context
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        // Add some sort descriptors
        
        let englishSortDescriptor = NSSortDescriptor(keyPath: \Word.englishWord, ascending: true)
        let foriegnSortDescriptor = NSSortDescriptor(keyPath: \Word.foriegnWord, ascending: true)
        request.sortDescriptors = [foriegnSortDescriptor, englishSortDescriptor]
 
        if let pred = predicate {
            // need to make a compound predicate
            request.predicate = pred
        }
        
        do {
            words = try context.fetch(request)
        }
        catch {
            print("Error loading words \(error)")
        }
        tableView.reloadData()
    }

}

