//
//  FlashcardViewController.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 11/28/20.
//

import UIKit

class FlashcardViewController: UIViewController {

    @IBOutlet var statisticsLabel: UILabel!
    @IBOutlet var markedReviewButton: UIButton!
    @IBOutlet var flashcardButton: UIButton!
    @IBOutlet var revealMnemonicButton: UIButton!
    @IBOutlet var prevButton: UIButton!
    @IBOutlet var nextButton: UIButton!
        
    
    var flashcardSetOptional: [Word]? = nil
    var currentIndexOptional: Int? = nil
    
    var wordOptional: Word? = nil
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Loaded Flashcard View")
        // Do any additional setup after loading the view.
        
        if let _ = flashcardSetOptional {
            currentIndexOptional = -1 // Set the starting index if there are words available
        } else {
            currentIndexOptional = nil
        }
        
        showNewFlashcard()
        
        print("MOVE THE SPEECH SYNTH CODE TO EVENTUAL HOME SCREEN!")
        SpeechSynthesizer.languageCode = LanguageCode.germanDE
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Vocab Table View Controller will appear")
        refreshWords()
    }
    
    // MARK: New Flashcard Methods
    
    func showNewFlashcard() {
        if let flashcardSet = flashcardSetOptional, let currentIndex = currentIndexOptional {
            currentIndexOptional = (currentIndex + 1) % flashcardSet.count
            wordOptional = flashcardSet[currentIndexOptional!]
        } else {
            wordOptional = nil
        }
        
        updateFlashcard(with: wordOptional)
    }
    
    func updateFlashcard(with wordOptional: Word?) {
        if let word = wordOptional {
            // Set the flashcard button text to be that of the foriegn word
            flashcardButton.setTitle(word.foriegnWord, for: .normal)
            // Update the statistics Label
            if word.timesCorrect == 0 && word.timesMissed == 0 {
                statisticsLabel.text = "No statistics yet"
            } else if word.timesMissed == 0 {
                statisticsLabel.text = "100% Right"
            } else {
                statisticsLabel.text = "\(100*word.timesCorrect/word.timesMissed)% Right"
            }
            // See if the word is marked for review
            if word.markedForReview { markedReviewButton.setTitle("★", for: .normal) }
            else { markedReviewButton.setTitle("☆", for: .normal) }
        } else { // No words are in the set. tell the user
            flashcardButton.setTitle("You don't have any words yet!", for: .normal)
            statisticsLabel.text = "Statistics not available"
            markedReviewButton.setTitle("☆", for: .normal)
        }
    }
    
    // MARK: IBAction Methods
    
    @IBAction func prevButtonPressed(_ sender: UIButton) {
        if let currentIndex = currentIndexOptional, let flashcardSet = flashcardSetOptional {
            currentIndexOptional = (currentIndex - 1) % flashcardSet.count // Make sure that the index wraps
            self.wordOptional = flashcardSet[currentIndexOptional!]
        } else {
            self.wordOptional = nil
        }
        updateFlashcard(with: self.wordOptional)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if let currentIndex = currentIndexOptional, let flashcardSet = flashcardSetOptional {
            currentIndexOptional = (currentIndex + 1) % flashcardSet.count // Make sure that the index wraps
            self.wordOptional = flashcardSet[currentIndexOptional!]
        } else {
            self.wordOptional = nil
        }
        updateFlashcard(with: self.wordOptional)
    }
    
    @IBAction func flashcardButtonPressed(_ sender: UIButton) {
        if flashcardButton.title(for: .normal) == wordOptional?.foriegnWord {
            flashcardButton.setTitle(wordOptional?.englishWord, for: .normal)
        } else {
            flashcardButton.setTitle(wordOptional?.foriegnWord, for: .normal)
        }
    }
    
    @IBAction func speakerButtonPressed(_ sender: UIButton) {
        if let word = wordOptional {
            SpeechSynthesizer.speak(phrase: word.foriegnWord)
        }
    }
    
    @IBAction func markedReviewButtonPressed(_ sender: UIButton) {
        if markedReviewButton.titleLabel?.text == "☆" { markedReviewButton.setTitle("★", for: .normal)
            wordOptional?.markedForReview = true
        } else {
            markedReviewButton.setTitle("☆", for: .normal)
            wordOptional?.markedForReview = false
        }
        
        // Save the changes and refresh the datasource
        DatabaseManager.saveWords()
        refreshWords()
    }
    
    @IBAction func revealMnemonicPressed(_ sender: UIButton) {
        if revealMnemonicButton.title(for: .normal) == "Reveal Mnemonic" {
            if let mnemonic = wordOptional?.mnemonic {
                revealMnemonicButton.setTitle(mnemonic, for: .normal)
            } else {
                revealMnemonicButton.setTitle("No mnemonic set", for: .normal)
            }
        } else {
            revealMnemonicButton.setTitle("Reveal Mnemonic", for: .normal)
        }
    }
    
    @IBAction func addMnemonicPressed(_ sender: UIButton) {
        // Show an alert to get text for a mnemonic
        let alert = UIAlertController(title: "Add Mnumonic",
            message: "Add a word/phrase that helps you remember this word",
            preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { [self] (action) -> Void in
            // Get the text and set it as the words mnemonic
            let textField = alert.textFields![0]
            if let flashcardSet = self.flashcardSetOptional, let currentIndex = self.currentIndexOptional {
                if !textField.text!.isEmpty {
                    flashcardSet[currentIndex].mnemonic = textField.text!
                    // Save and refresh the changes
                    DatabaseManager.saveWords()
                    refreshWords()
                }
            }
         })
        // Cancel button
          let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil )
        // Add the text field and actions
        alert.addTextField { (textField: UITextField) in
            textField.keyboardType = .default
            if let flashcardSet = self.flashcardSetOptional, let currentIndex = self.currentIndexOptional {
                textField.text = flashcardSet[currentIndex].mnemonic
            }
        }
        alert.addAction(submitAction)
        alert.addAction(cancel)
        // Show the alert
        present(alert, animated: true, completion: nil)
    }
    
    // This reloads the words and recomputes the currentIndex
    func refreshWords() {
        // flashcardSetOptional = DatabaseManager.loadWords()
        if let flashcardSet = flashcardSetOptional, let currentIndex = currentIndexOptional {
            currentIndexOptional = currentIndex % flashcardSet.count // Make sure that the index wraps
        } else {
            currentIndexOptional = nil
        }
    }
    
}


@IBDesignable extension UIButton {
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
