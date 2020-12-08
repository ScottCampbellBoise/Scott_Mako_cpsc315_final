//
//  VocabTableViewCell.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 11/27/20.
//

import UIKit

class VocabTableViewCell: UITableViewCell {

    @IBOutlet var foriegnLabel: UILabel!
    @IBOutlet var englishLabel: UILabel!
    @IBOutlet var mneumonicLabel: UILabel!
    @IBOutlet var statisticsLabel: UILabel!
    @IBOutlet var markedReviewButton: UIButton!
    
    var wordOptional: Word? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func speakerButtonPressed(_ sender: UIButton) {
        if let word = wordOptional {
            SpeechSynthesizer.speak(phrase: word.foriegnWord)
        }
    }
    
    @IBAction func markedForReviewPressed(_ sender: UIButton) {
        if markedReviewButton.titleLabel?.text == "☆" { markedReviewButton.setTitle("★", for: .normal)
            wordOptional?.markedForReview = true
        } else {
            markedReviewButton.setTitle("☆", for: .normal)
            wordOptional?.markedForReview = false
        }
        
        // Save the changes to the context
        do {
            try DatabaseManager.context.save()
        } catch {
            print("Error saving the changes in Words: \(error)")
        }
    }
    
    func update(with word: Word) {
        self.wordOptional = word
        
        englishLabel.text = word.englishWord
        foriegnLabel.text = word.foriegnWord
        // See if the word is marked for review
        if word.markedForReview { markedReviewButton.setTitle("★", for: .normal) }
        else { markedReviewButton.setTitle("☆", for: .normal) }
        // Determine the statistics for the word
        if word.timesCorrect == 0 && word.timesMissed == 0 {
            statisticsLabel.text = "No statistics yet"
        } else if word.timesMissed == 0 {
            statisticsLabel.text = "100% Right"
        } else {
            statisticsLabel.text = "\(100*word.timesCorrect/word.timesMissed)% Right"
        }
        // Now try to unwrap additional information
        if let mneumonic = word.mnemonic {
            mneumonicLabel.text = mneumonic
        } else {
            mneumonicLabel.text = ""
        }
    }

}
