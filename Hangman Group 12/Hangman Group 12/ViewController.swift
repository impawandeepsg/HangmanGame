//
//  ViewController.swift
//  Hangman Group 12
//
//  Created by Pawandeep Singh on 2023-10-26.
//

import UIKit

class ViewController: UIViewController {
    //IBOutlets
    @IBOutlet weak var numberOfWinLabel: UILabel!
    @IBOutlet weak var lossesCounterLabel: UILabel!
    @IBOutlet weak var gussesLabel: UILabel!
    @IBOutlet weak var faceLabel: UILabel!
    @IBOutlet var answerLabelArray: [UILabel]!
    @IBOutlet var lettersButtonsArray: [UIButton]!
    @IBOutlet var hangmanPartsArray: [UIView]!
    
    //Variables
    var numberOfGusses = 7
    var numberOfWins = 0
    var numberOfLosses = 0
    var currentHangmanIndex = 0
    
    let words = ["justice",
 		"dynamic",
 		"jealous",
 		"mailbox",
 		"journey",
 		"combine",
 		"harmony",
 		"whistle",
 		"kitchen",
 		"quality",
 		"auction",
 		"factory",
 		"flowers"]
    
    var currentWord = ""
    var currentWordCopy = ""
    
    //Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrentWord()
        hangmanPartsArray[2].transform = CGAffineTransformMakeRotation(45 * .pi/180)
        hangmanPartsArray[3].transform = CGAffineTransformMakeRotation(-45 * .pi/180)
        hangmanPartsArray[5].transform = CGAffineTransformMakeRotation(45 * .pi/180)
        hangmanPartsArray[6].transform = CGAffineTransformMakeRotation(-45 * .pi/180)
        
        
        hangmanPartsArray.forEach { view in
            view.isHidden = true
        }
        
        answerLabelArray.forEach { label in
            label.text = "_"
        }

    }
    
    //Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gussesLabel.text = "Gusses: \(numberOfGusses)"
    }
    private func setCurrentWord() {
        currentWord = words.randomElement() ?? words[0]
        currentWordCopy = currentWord
    }
    
    //IBActions
    @IBAction func letterTapped(_ sender: UIButton) {
        guard let letterTapped = sender.titleLabel?.text else { return }
        checkLetter(letterTapped.lowercased(), button: sender)
    }
    
    //Private Methods
    private func checkLetter(_ letter: String, button: UIButton) {
        if currentWord.contains(letter) {
            let indexOfLetter = currentWord.firstIndex(of: Character(letter))!
            let index: Int = currentWord.distance(from: currentWord.startIndex, to: indexOfLetter)
            revelLetter(index: index, letter)
            currentWord.replaceSubrange(indexOfLetter...indexOfLetter, with: "_")

            button.backgroundColor = .green
        } else {
            button.backgroundColor = .red
            hangmanPartsArray[currentHangmanIndex].isHidden = false
            currentHangmanIndex += 1
            numberOfGusses -= 1
        }
        
        button.isUserInteractionEnabled = false
        gussesLabel.text = "Gusses: \(numberOfGusses)"
        

        if currentWord == "_______" {
            showWinningPopUp()
            numberOfWins += 1
            faceLabel.isHidden = false
            faceLabel.text = "😶"
        } else if numberOfGusses == 0 {
            showLosingPopup()
            numberOfLosses += 1
            faceLabel.isHidden = false
            faceLabel.text = "😵"
        }
    }
    
    private func showWinningPopUp() {
        let alert = UIAlertController(title: "Woohoo!",
                                      message: "You saved me! Would you like to play again?",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: UIAlertAction.Style.default,
                                      handler: {_ in
            self.resetGame()
            
        }))
    
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showLosingPopup() {
        let alert = UIAlertController(title: "Uh oh",
                                      message: "The correct word was '\(currentWordCopy.uppercased())'. Would you like to try again?",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: UIAlertAction.Style.default,
                                      handler: {_ in
            self.resetGame()
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
        self.present(alert, animated: true, completion: nil)
    }
    
    private func resetGame() {
        self.setCurrentWord()
        self.answerLabelArray.forEach { label in
            label.text = "_"
        }
        self.lettersButtonsArray.forEach { button in
            button.isUserInteractionEnabled = true
            button.backgroundColor = .lightGray
        }
        self.hangmanPartsArray.forEach { view in
            view.isHidden = true
        }
        numberOfGusses = 7
        gussesLabel.text = "Gusses: \(numberOfGusses)"
        numberOfWinLabel.text = "\(numberOfWins)"
        lossesCounterLabel.text = "\(numberOfLosses)"
        currentHangmanIndex = 0
        faceLabel.isHidden = true
    }
    
    private func revelLetter(index: Int, _ letter: String) {
        answerLabelArray[index].text = letter.uppercased()
    }
}

