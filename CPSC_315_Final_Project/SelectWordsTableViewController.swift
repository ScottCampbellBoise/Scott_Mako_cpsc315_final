//
//  SelectWordsTableViewController.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 12/9/20.
//

import UIKit

class StudysetDetailTableViewController: UITableViewController, UISearchBarDelegate {

    // SelectWordCell
        
    // Define the data source for the Table View
    var words = [Word]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        return cell
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
