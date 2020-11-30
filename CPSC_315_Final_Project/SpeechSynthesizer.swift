//
//  SpeechSynthesizer.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 11/30/20.
//

import Foundation
import AVFoundation

class SpeechSynthesizer: CustomStringConvertible {
    static var languageCode = LanguageCode.englishUS
    
    var description: String {
        return "Speech Synthesizer Langauge: \(SpeechSynthesizer.languageCode.rawValue)"
    }
    
    // Define settings for how the phase is said
    static let speechRate: Float = 0.40
    static let pitchMultiplier: Float = 0.8
    static let postUtteranceDelay: Double = 0.2
    static let volume: Float = 1.0
    
    static func speak(phrase: String) {
        // Define the utterance (how the phrase is to be said)
        let utterance = AVSpeechUtterance(string: phrase)
        utterance.rate = self.speechRate
        utterance.pitchMultiplier = self.pitchMultiplier
        utterance.postUtteranceDelay = self.postUtteranceDelay
        utterance.volume = self.volume
        // Define the voice that will say the phrase
        let voice = AVSpeechSynthesisVoice(language: languageCode.rawValue)
        // Assign the voice to the utterance.
        utterance.voice = voice
        // Create a speech synthesizer.
        let synthesizer = AVSpeechSynthesizer()
        // Tell the synthesizer to speak the utterance.
        synthesizer.speak(utterance)
    }
    
}

// Add other language codes here!
// To find the correct BCP 47 Language Code, go to https://appmakers.dev/bcp-47-language-codes-list/
enum LanguageCode: String {
    case englishUS = "en-US" // US English
    case englishGB = "en-GB" // Great Brittan English
    case germanDE = "de-DE" // Germany German
}

