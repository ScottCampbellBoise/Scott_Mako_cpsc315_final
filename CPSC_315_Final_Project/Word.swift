//
//  Word.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 11/27/20.
//

import Foundation

class Word: CustomStringConvertible {
    var englishWord: String
    var foriegnWord: String
    var language: String // The langauage the foriegn word is in?
    
    var markedForReview: Bool = false // User wants to spend extra time
    var mnemonic: String? = nil // A key phrase to help remember the word
    var timesMissed: Int? = nil
    var timesCorrect: Int? = nil
    
    var description: String {
        return "\(englishWord) - \(foriegnWord) (\(language))"
    }
    
    init(english: String, foriegn: String, language: String) {
        self.englishWord = english
        self.foriegnWord = foriegn
        self.language = language
    }
}
