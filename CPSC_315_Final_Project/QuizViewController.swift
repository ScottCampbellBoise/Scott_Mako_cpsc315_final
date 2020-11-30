//
//  QuizViewController.swift
//  CPSC_315_Final_Project
//
//  Created by Makoto Kewish on 11/29/20.
//

import UIKit

class QuizViewController: UIViewController {
    
    var numHints = 3
    var hint: String?
    
    @IBOutlet var foreignWordLabel: UILabel!
    @IBOutlet var englishTextField: UITextField!
    @IBOutlet var hintButtonLabel: UIButton!
    @IBOutlet var correctLabel: UILabel!

    // TODO: Figure out how to randomly select words from database and onto quiz view...
    var word: Word? = nil
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var foreignWord = "" {
        didSet {
            if let foreignWord = word?.foriegnWord {
                foreignWordLabel.text = "\(foreignWord)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded Quiz View")
        
        updateHintLabel()
        updateCorrectLabel()
    }
    
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        if let userInputOp = englishTextField.text {
            let userInput = userInputOp.uppercased()
            if let answer = word?.englishWord {
                if answer.uppercased() == userInput {
                    word?.timesCorrect += 1
                    
                    let correctMessage = "Correct! Keep it up!"
                    let alertController = UIAlertController(title: "Correct", message: correctMessage, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                        print("User pressed okay")
                        self.changeNumHints(reset: true)
                            
                    }))
                    present(alertController, animated: true, completion: { () -> Void in
                        print("Presented Correct alert")
                    })
                } else {
                    word?.timesMissed -= 1
                    
                    let incorrectMessage = "Your answer is incorrect. Try pressing the Hint or Reveal Answer button."
                    let alertController = UIAlertController(title: "Incorrect", message: incorrectMessage, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                        print("User pressed okay")
                            
                    }))
                    present(alertController, animated: true, completion: { () -> Void in
                        print("Presented Incorrecr alert")
                    })
                }
                
                do {
                    try context.save()
                } catch {
                    print("Error saving the changes in Words: \(error)")
                }
            }
        }
        invalidInputAlert()
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
            let hintMessage = "\(hint)\nNumber of hints remaining: \(numHints)."
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
        if let answer = word?.englishWord {
            let answerMessage = "Answer is \(answer).\nCorrect percentage will drop."
            let alertController = UIAlertController(title: "Answer", message: answerMessage, preferredStyle: .alert)
        
            alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                print("User pressed okay")
                self.numHints = 0
                self.updateHintLabel()
                
            }))
            present(alertController, animated: true, completion: { () -> Void in
                print("Presented Answer alert")
            })
            
            word?.timesMissed -= 1
            do {
                try context.save()
            } catch {
                print("Error saving the changes in Words: \(error)")
            }
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
        if let correct = word?.timesCorrect, let wrong = word?.timesMissed {
            if correct == 0 && wrong == 0 {
                correctLabel.text = "Correct: %"
            }
            else {
                let percentage = correct / (correct + wrong)
                correctLabel.text = "Correct: \(percentage)%"
            }
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
}

