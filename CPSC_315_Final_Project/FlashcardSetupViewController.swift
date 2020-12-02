//
//  FlashcardSetupViewController.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 12/1/20.
//

import UIKit

class FlashcardSetupViewController: UIViewController {

    // NOTE: This class is a shell - its implementation should be changed/improved in the future
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "FlashcardSegue" {
                // TODO: Allow the user to select from different study sets
            }
        }
    }

}
