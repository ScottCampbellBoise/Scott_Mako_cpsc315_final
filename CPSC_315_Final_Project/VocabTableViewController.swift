//
//  ViewController.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 11/27/20.
//

import UIKit

class VocabTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    // MARK: TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    // MARK: - Search Bar Delegate Method(s)
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     
    }
    
    func performSearch(searchBar: UISearchBar) {
        if let input = searchBar.text {
            
        }
    }

}

