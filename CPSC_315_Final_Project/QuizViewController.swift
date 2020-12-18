//
//  QuizViewController.swift
//  CPSC_315_Final_Project
//
//  Created by Makoto Kewish on 11/29/20.
//

import UIKit

// For now: Displays foreign word, user has to match its english word via a textfield
//          Diplays the percentage of the user getting the word right
//          by using values from timesCorrect and timesMissed
//          Provides hints (max 3) and a reveal answer button
//          Added swipe gestures so user can move on or come back to previous questions

class QuizViewController: UIViewController {
    
    var numHints = 3
    var hint: [String]?
    var englishWord: [String] = []
        
    @IBOutlet var foreignWordLabel: UILabel!
    @IBOutlet var englishTextField: UITextField!
    @IBOutlet var correctLabel: UILabel!
    
    var flashcardSetOptional: [Word]? = nil
    var currentIndexOptional: Int? = nil
    var wordOptional: Word? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded Quiz View")
    
        //flashcardSetOptional = DatabaseManager.loadWords()
        if let _ = flashcardSetOptional {
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
            hint = nil
            foreignWordLabel.text = word.foriegnWord
            englishTextField.text = ""
            updateCorrectLabel()
        } else {
            foreignWordLabel.text = ""
        }
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
                        DatabaseManager.saveWords()
                        
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
                        DatabaseManager.saveWords()
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
    
    
    @IBAction func mnemonicButtonPressed(_ sender: UIButton) {
        if let word = wordOptional {
            if let mnemonic = word.mnemonic {
                let mnemonicMessage = "Mnemonic: \(mnemonic)"
                let alertController = UIAlertController(title: "Mnemonic", message: mnemonicMessage, preferredStyle: .alert)
            
                alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                print("User pressed okay")
                    
                }))
                present(alertController, animated: true, completion: { () -> Void in
                print("Presented Mnuemonic alert")
                })
            } else {
                let mnemonicMessage = "A mnenomic has not been set for this word."
                let alertController = UIAlertController(title: "Mnemonic", message: mnemonicMessage, preferredStyle: .alert)
        
                alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                    print("User pressed okay")
                
                }))
                present(alertController, animated: true, completion: { () -> Void in
                    print("Presented Mnuemonic alert")
                })
            }
        }
    }
    
    
    @IBAction func revealAnswerButtonPressed(_ sender: UIButton) {
        if let answer = wordOptional {
            let answerMessage = "Answer is \(answer.englishWord).\nCorrect percentage will drop."
            let alertController = UIAlertController(title: "Answer", message: answerMessage, preferredStyle: .alert)
        
            alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                print("User pressed okay")
                answer.timesMissed += 1
                DatabaseManager.saveWords()
                
                // move on to next question
                self.swipedLeft()
                
            }))
            present(alertController, animated: true, completion: { () -> Void in
                print("Presented Answer alert")
            })
        }
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
    
    func hintAlert() {
        let invalidMessage = "Hint:\n\(hint!.joined(separator: " "))"
        let alertController = UIAlertController(title: "Hint", message: invalidMessage, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
            print("User pressed okay")
        }))
        present(alertController, animated: true, completion: { () -> Void in
            print("Presented Hint alert")
        })
    }
}


