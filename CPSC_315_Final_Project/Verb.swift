//
//  Verb.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 11/27/20.
//

import Foundation

// This class should the conjugations of a verb for different tenses
class Verb: Word {
    
    // I am just going to start by implementing the present tense
    var presentTense: [String]
    
    init(english: String, foriegn: String, language: String, presentTense: [String]) {
        // Do the verb-specific initialization here
        self.presentTense = presentTense
        
        // Call the super class initializer
        super.init(english: english, foriegn: foriegn, language: language)
    }
    
    
}
