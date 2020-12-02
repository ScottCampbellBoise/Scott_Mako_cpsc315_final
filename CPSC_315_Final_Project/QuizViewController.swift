//
//  QuizViewController.swift
//  CPSC_315_Final_Project
//
//  Created by Makoto Kewish on 11/29/20.
//

import UIKit
import CoreData

// For now: Displays foreign word, user has to match its english word via a textfield
//          Diplays the percentage of the user getting the word right
//          by using values from timesCorrect and timesMissed
//          Provides hints (max 3) and a reveal answer button
//          Added swipe gestures so user can move on or come back to previous questions

class QuizViewController: UIViewController {
    
    var numHints = 3
    var hint: String?
        
    @IBOutlet var foreignWordLabel: UILabel!
    @IBOutlet var englishTextField: UITextField!
    @IBOutlet var hintButtonLabel: UIButton!
    @IBOutlet var correctLabel: UILabel!

    // TODO: Implement the connection for allowing the user to choose a study set
    // TODO: Figure out how to randomly select words from database and onto quiz view...
    //      Might have to add another attribute like a unique id for each word...
    var flashcardSetOptional: [Word]? = nil
    var currentIndexOptional: Int? = nil
    
    var wordOptional: Word? = nil
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded Quiz View")
    
        flashcardSetOptional = loadWords()
        if let flashcardSet = flashcardSetOptional {
            currentIndexOptional = -1 // Set the starting index if there are words available
        } else {
            currentIndexOptional = nil
        }
        
        showQuiz()
        
        // Swipe gestures for left and right swipe
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        leftRecognizer.direction = .left
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        rightRecognizer.direction = .right
        
        self.view.addGestureRecognizer(leftRecognizer)
        self.view.addGestureRecognizer(rightRecognizer)
        
        print("MOVE THE SPEECH SYNTH CODE TO EVENTUAL HOME SCREEN!")
        SpeechSynthesizer.languageCode = LanguageCode.germanDE
        
    }
    
    @IBAction func speakerButtonPressed(_ sender: UIButton) {
        if let word = wordOptional {
            SpeechSynthesizer.speak(phrase: word.foriegnWord)
        }
    }
    
    @IBAction func checkAnswerButtonPressed(_ sender: UIButton) {
        if let userInputOp = englishTextField.text {
            let userInput = userInputOp.uppercased()
            if let answer = wordOptional{
                if answer.englishWord.uppercased() == userInput {
                    answer.timesCorrect += 1
                    
                    let correctMessage = "Correct! Keep it up!"
                    let alertController = UIAlertController(title: "Correct", message: correctMessage, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: "Next Question", style: .default, handler: { (action) -> Void in
                        print("User pressed okay")
                        self.saveWord()
                        
                        self.changeNumHints(reset: true)
                        
                        // move on to next question
                        self.swipedLeft()
                            
                    }))
                    present(alertController, animated: true, completion: { () -> Void in
                        print("Presented Correct alert")
                    })
                } else {
                    answer.timesMissed += 1
                    
                    let incorrectMessage = "Your answer is incorrect. Try pressing the Hint or Reveal Answer button or come back to this one later."
                    let alertController = UIAlertController(title: "Incorrect", message: incorrectMessage, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                        print("User pressed okay")
                        self.saveWord()
                            
                    }))
                    present(alertController, animated: true, completion: { () -> Void in
                        print("Presented Incorrect alert")
                    })
                }
            }
        }
        invalidInputAlert()
    }
    
    
    @IBAction func swipeHandler(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            if gestureRecognizer.direction == .right {
                print("Swiped right to previous question.")
                swipedRight()
            }
            if gestureRecognizer.direction == .left {
                print("Swiped left to next question.")
                swipedLeft()
            }
        }
    }
    
    
    func swipedLeft() {
        if let currentIndex = currentIndexOptional, let flashcardSet = flashcardSetOptional {
            currentIndexOptional = (currentIndex + 1) % flashcardSet.count // Make sure that the index wraps
            self.wordOptional = flashcardSet[currentIndexOptional!]
        } else {
            self.wordOptional = nil
        }
        updateQuiz(with: self.wordOptional)
    }
    
    
    func swipedRight() {
        if let currentIndex = currentIndexOptional, let flashcardSet = flashcardSetOptional {
            currentIndexOptional = (currentIndex - 1) % flashcardSet.count // Make sure that the index wraps
            self.wordOptional = flashcardSet[currentIndexOptional!]
        } else {
            self.wordOptional = nil
        }
        updateQuiz(with: self.wordOptional)
    }
    
    
    @IBAction func hintButtonPressed(_ sender: UIButton) {
        if numHints == 0 {
            let hintMessage = "No more hints remaining..."
            let alertController = UIAlertController(title: "Hint", message: hintMessage, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                print("User pressed okay")
                    
            }))
            present(alertController, animated: true, completion: { () -> Void in
                print("Presented Hint alert")
            })
        } else {
            let hint = provideHint()
            
            let hintMessage = "\(hint)\nNumber of hints remaining: \(numHints - 1)."
            let alertController = UIAlertController(title: "Hint", message: hintMessage, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                print("User pressed okay")
                self.changeNumHints(reset: false)
                self.updateHintLabel()
                    
            }))
            present(alertController, animated: true, completion: { () -> Void in
                print("Presented Hint alert")
            })
        }
    }
    
    
    @IBAction func revealAnswerButtonPressed(_ sender: UIButton) {
        if let answer = wordOptional {
            let answerMessage = "Answer is \(answer.englishWord).\nCorrect percentage will drop."
            let alertController = UIAlertController(title: "Answer", message: answerMessage, preferredStyle: .alert)
        
            alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                print("User pressed okay")
                answer.timesMissed += 1
                self.saveWord()
                
                // move on to next question
                self.swipedLeft()
                
                self.changeNumHints(reset: true)
                self.updateHintLabel()
            }))
            present(alertController, animated: true, completion: { () -> Void in
                print("Presented Answer alert")
            })
        }
    }
    
    func changeNumHints(reset: Bool) {
        if reset == true {
            numHints = 3
        }
        else {
            numHints -= 1
        }
    }
    
    // TODO: Fix this...
    func provideHint() -> String {
        /*if let hintExists = hint {
            let letter = Int.random(in: 0...hintExists.count - 1)
            hintExists.index
        }
        else {
            if let word = word?.englishWord {
                hint = word
            
                let letter = Int.random(in: 0...hint!.count - 1)
            
            }
        }*/
        return "Hint"
    }
    
    
    func updateHintLabel() {
        hintButtonLabel.setTitle("Hints: \(numHints)", for: .normal)
    }
    
    
    func updateCorrectLabel() {
        if let word = wordOptional {
            let correct = word.timesCorrect
            let wrong = word.timesMissed
            
            if correct == 0 && wrong == 0 {
                correctLabel.text = "Correct: %"
            }
            else {
                let percentage = 100 * correct / (correct + wrong)
                correctLabel.text = "Correct: \(percentage)%"
            }
        } else {
            correctLabel.text = "Correct: %"
        }
    }
    
    
    func invalidInputAlert() {
        let invalidMessage = "Invalid input. Please type english word/guess in the provided text field."
        let alertController = UIAlertController(title: "Invalid Input", message: invalidMessage, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
            print("User pressed okay")
        }))
        present(alertController, animated: true, completion: { () -> Void in
            print("Presented Invalid alert")
        })
    }
    
    
    func showQuiz() {
        if let flashcardSet = flashcardSetOptional, let currentIndex = currentIndexOptional {
            currentIndexOptional = (currentIndex + 1) % flashcardSet.count
            wordOptional = flashcardSet[currentIndexOptional!]
        } else {
            wordOptional = nil
        }
        
        updateQuiz(with: wordOptional)
    }
    
    
    func updateQuiz(with wordOptional: Word?) {
        if let word = wordOptional {
            foreignWordLabel.text = word.foriegnWord
            updateHintLabel()
            updateCorrectLabel()
        } else {
            foreignWordLabel.text = ""
        }
    }
    
    
    func saveWord() {
        do {
            try context.save()
        }
        catch {
            print("Error saving the changes in Words: \(error)")
        }
    }
    
    
    func loadWords() -> [Word]? {
        // we need to "request" the categories from the database (using the persistent container's context
        // Need to fetch request from study set instead....
        
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        //let request: NSFetchRequest<StudySet> = StudySet.fetchRequest()
        do {
            let words = try context.fetch(request)
            return words
        }
        catch {
            print("Error loading words \(error)")
            return nil
        }
    }
    
}

