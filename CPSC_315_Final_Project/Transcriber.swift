//
//  Transcriber.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 12/12/20.
//

import Foundation

//
//  Transcribe.swift
//  SpeechToTextFun
//
//  Created by Scott Campbell on 12/12/20.
//
// Acknowledgements:
//   https://stackoverflow.com/questions/26472747/recording-audio-in-swift
//

import Foundation
import Speech

class Transcriber {
    
    static func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Good to go!")
                } else {
                    print("Transcription permission was declined.")
                }
            }
        }
    }
    
    static func transcribeAudio(url: URL, completion: @escaping (String?) -> Void) {
        // create a new recognizer and point it at our audio
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: LanguageCode.germanDE.rawValue))
        let request = SFSpeechURLRecognitionRequest(url: url)

        // start recognition!
        recognizer?.recognitionTask(with: request) { (result, error) in
            // abort if we didn't get any transcription back
            guard let result = result else {
                print("There was an error: \(error!)")
                completion(nil)
                return
            }

            // if we got the final transcription back, print it
            if result.isFinal {
                // pull out the best transcription...
                completion(result.bestTranscription.formattedString)
            }
        }
        completion("")
    }
    
    static func getAudioFileUrl() -> URL {
        let filename = "pronunciationRecording.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}
