//
//  SpeechPracticeViewController.swift
//  CPSC_315_Final_Project
//
//  Created by Scott Campbell on 12/12/20.
//

import UIKit
import AVFoundation

class SpeechPracticeViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet var recordButton: UIButton!
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var transcribedLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!

    var audioRecorder: AVAudioRecorder!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    
    var wordOptional: Word?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Transcriber.requestTranscribePermissions()
        checkRecordPermission()
        
        update(with: wordOptional)
    }
    
    func update(with wordOptional: Word?) {
        self.wordOptional = wordOptional
        if let word = wordOptional {
            print("Practice for word: \(word)")
            wordLabel.text = word.foriegnWord
            transcribedLabel.text = "No transcription yet..."
            statusLabel.text = "No recording yet..."
        }
    }
    
    // MARK: IBActions
    
    @IBAction func speakerButtonPressed(_ sender: UIButton) {
        if let word = wordOptional {
            SpeechSynthesizer.speak(phrase: word.foriegnWord)
        }
    }
    
    @IBAction func startRecording(_ sender: UIButton) {
        if(isRecording) {
            finishAudioRecording(success: true)
            recordButton.setTitle("Start Recording", for: .normal)
            isRecording = false
            
        }
        else {
            setupRecorder()

            audioRecorder.record()
            recordButton.setTitle("Stop Recording", for: .normal)
            isRecording = true
        }
        transcribedLabel.text = "Transcribing..."
        statusLabel.text = "Waiting for results..."
    }
    
    // MARK: Recording Methods
    
    func setupRecorder() {
        if isAudioRecordingGranted {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: Transcriber.getAudioFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = false
                audioRecorder.prepareToRecord()
            }
            catch let error {
                displayAlert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
            }
        }
        else {
            displayAlert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
        }
    }
    
    func displayAlert(msg_title : String , msg_desc : String ,action_title : String) {
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default) {
            (result : UIAlertAction) -> Void in
        _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finished Recording")
        if !flag {
            finishAudioRecording(success: false)
        }
    }

    func finishAudioRecording(success: Bool) {
        print("Finished Recording")
        if success {
            audioRecorder.stop()
            audioRecorder = nil
            print("recorded successfully.")
            
            print("Attempting to transcribe the audio...")
            Transcriber.transcribeAudio(url: Transcriber.getAudioFileUrl()) { (transOptional) in
                if let trans = transOptional {
                    self.transcribedLabel.text = trans
                    print("TO DO: Update Status Label Accordingly")
                    self.statusLabel.text = "UPDATE STATUS"
                } else {
                    self.displayAlert(msg_title: "Error", msg_desc: "Could not get a transcription of the recording", action_title: "")
                }
            }
            
        }
        else {
            displayAlert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
        }
    }
    
    func checkRecordPermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
            case AVAudioSessionRecordPermission.granted:
                isAudioRecordingGranted = true
                break
            case AVAudioSessionRecordPermission.denied:
                isAudioRecordingGranted = false
                break
            case AVAudioSessionRecordPermission.undetermined:
                AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                        if allowed {
                            self.isAudioRecordingGranted = true
                        } else {
                            self.isAudioRecordingGranted = false
                        }
                })
                break
            default:
                break
        }
    }
    
}
