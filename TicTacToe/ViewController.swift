//
//  ViewController.swift
//  TicTacToe
//
//  Created by Bishwajit Yadav on 15/06/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    enum Turn {
        case Nought
        case Cross
    }
    
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    
    
    
    var firstTurn = Turn.Cross
    var curTurn = Turn.Nought
    var Board = [UIButton]()
    var victorySoundPlayer: AVAudioPlayer?
    var gameOverSoundPlayer: AVAudioPlayer?
    var btnTappedSoundPlayer: AVAudioPlayer?
    var Nought = "O"
    var Cross = "X"
    
    var noughtScore = 0
    var crossScore = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
      initBTn()
        setupGameOverSound()
    }
    
    func initBTn () {
        Board.append(a1)
        Board.append(a2)
        Board.append(a3)
        Board.append(b1)
        Board.append(b2)
        Board.append(b3)
        Board.append(c1)
        Board.append(c2)
        Board.append(c3)

        
    }
    
    
    func thisSymbol(_ button:UIButton,_ symbol:String)->Bool {
        return button.title(for: .normal) == symbol
    }
    
    func checkVictory(_ s : String) -> Bool {
        //Horizontal victory
        if thisSymbol(a1, s) && thisSymbol(a2,s ) && thisSymbol(a3, s) {
            return true
        }
        if thisSymbol(b1, s) && thisSymbol(b2,s ) && thisSymbol(b3, s) {
            return true
        }
        if thisSymbol(c1, s) && thisSymbol(c2,s ) && thisSymbol(c3, s) {
            return true
        }
        //Vertical victory

        if thisSymbol(a1, s) && thisSymbol(b1,s ) && thisSymbol(c1, s) {
            return true
        }
        if thisSymbol(a2, s) && thisSymbol(b2,s ) && thisSymbol(c2, s) {
            return true
        }
        if thisSymbol(a3, s) && thisSymbol(b3,s ) && thisSymbol(c3, s) {
            return true
        }
        //Daigonal victory

        if thisSymbol(a1, s) && thisSymbol(b2,s ) && thisSymbol(c3, s) {
            return true
        }
        if thisSymbol(a3, s) && thisSymbol(b2,s ) && thisSymbol(c1, s) {
            return true
        }
        
        return false
    }
    
    
    
    func fullBoard() -> Bool {
        for button in Board {
            if button.title(for: .normal) == nil{
                return false
            }
        }
        return true
    }
    
    
    func resultAlert(title: String){
        let message = "Nought Score : \(noughtScore)    " + "Cross Score : \(crossScore)"
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { _ in
            self.resetBoard()
        }))
        self.present(ac, animated: true)
    }
    
    func resetBoard(){
        for button in Board {
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        if(firstTurn == Turn.Nought ){
            firstTurn = Turn.Cross
            curTurn = Turn.Cross
        }
        else if(firstTurn == Turn.Cross ){
            firstTurn = Turn.Nought
            curTurn = Turn.Nought
        }
        curTurn = firstTurn
    }

    
    @IBAction func boardTypeAction(_ sender: UIButton) {
        
        addToBoard(sender)
        
        if checkVictory(Cross){
            crossScore += 1
           resultAlert(title: "Cross Win!!")
            setupVictorySound()
        }
        if checkVictory(Nought){
            noughtScore += 1
            resultAlert(title: "Nought Win!!")
            setupVictorySound()

         }
        if (fullBoard()){
            resultAlert(title: "Draw")
            setupGameOverSound()
        }
        
    }
    
    func addToBoard(_ sender:UIButton){
        if (sender.title(for:.normal) == nil) {
            if(curTurn == Turn.Nought ){
                sender.setTitle(Nought, for: .normal)
                curTurn = Turn.Cross
                turnLabel.text = Cross
                setupButtonTappedSound()
            }
           else if(curTurn == Turn.Cross ){
                sender.setTitle(Cross, for: .normal)
                curTurn = Turn.Nought
                turnLabel.text = Nought
               setupButtonTappedSound()
            }
            sender.isEnabled = false
            
        }
    }

}

extension ViewController {
    func setupVictorySound() {
        guard let soundURL = Bundle.main.url(forResource: "Win", withExtension: "mp3") else {
            print("Victory sound file not found")
            return
        }
        
        do {
            victorySoundPlayer = try AVAudioPlayer(contentsOf: soundURL)
            victorySoundPlayer?.play()
        } catch {
            print("Error loading victory sound file: \(error.localizedDescription)")
        }
    }

    func setupGameOverSound() {
        guard let soundURL = Bundle.main.url(forResource: "Draw", withExtension: "mp3") else {
            print("Game over sound file not found")
            return
        }
        
        do {
            gameOverSoundPlayer = try AVAudioPlayer(contentsOf: soundURL)
            gameOverSoundPlayer?.play()
        } catch {
            print("Error loading game over sound file: \(error.localizedDescription)")
        }
    }

    func setupButtonTappedSound() {
        guard let soundURL = Bundle.main.url(forResource: "tap", withExtension: "mp3") else {
            print("Button tapped sound file not found")
            return
        }
        
        do {
            btnTappedSoundPlayer = try AVAudioPlayer(contentsOf: soundURL)
            btnTappedSoundPlayer?.play()
        } catch {
            print("Error loading button tapped sound file: \(error.localizedDescription)")
        }
    }

}
