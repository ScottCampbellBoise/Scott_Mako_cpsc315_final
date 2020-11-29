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
    
    var word: Word? = nil
    
    // We need a reference to the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Loaded Flashcard View")
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func flashcardButtonPressed(_ sender: UIButton) {
        if flashcardButton.title(for: .normal) == word?.foriegnWord {
            flashcardButton.setTitle(word?.englishWord, for: .normal)
        } else {
            flashcardButton.setTitle(word?.foriegnWord, for: .normal)
        }
    }
    
    @IBAction func speakerButtonPressed(_ sender: UIButton) {
        print("ADD SPEAKER FUNCTIONALITY")
    }
    
    @IBAction func markedReviewButtonPressed(_ sender: UIButton) {
        if markedReviewButton.titleLabel?.text == "☆" { markedReviewButton.setTitle("★", for: .normal)
            word?.markedForReview = true
        } else {
            markedReviewButton.setTitle("☆", for: .normal)
            word?.markedForReview = false
        }
        
        // Save the changes to the context
        do {
            try context.save()
        } catch {
            print("Error saving the changes in Words: \(error)")
        }
    }
    
    @IBAction func revealMnemonicPressed(_ sender: UIButton) {
        if revealMnemonicButton.title(for: .normal) == "Reveal Mnemonic" {
            if let mnemonic = word?.mnemonic {
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
        print("ADD ALERT TO TYPE A MNEMONIC")
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
