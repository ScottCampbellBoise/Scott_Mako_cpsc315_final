//
//  SpeechSynthesisTEST.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 11/30/20.
//

import Foundation
import AVFoundation

// THIS IS JUST A TEST TO SEE HOW THE SPEECH SYNTHESIS WORKS

class SpeechSynthesisTEST {
    
    static func test() {
        // Create an utterance.
        let utterance = AVSpeechUtterance(string: "Hallo, mein Name ist Scott Campbell. Ich habe drei Geschwistern.")

        // Configure the utterance.
        utterance.rate = 0.40 // 0.57
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 1.0

        // Retrieve the British English voice.
        let voice = AVSpeechSynthesisVoice(language: "de-DE") // German - Germany Voice
        // See https://appmakers.dev/bcp-47-language-codes-list/ for all the codes for different languages

        // Assign the voice to the utterance.
        utterance.voice = voice
        
        // Create a speech synthesizer.
        let synthesizer = AVSpeechSynthesizer()

        // Tell the synthesizer to speak the utterance.
        synthesizer.speak(utterance)
    }
}
