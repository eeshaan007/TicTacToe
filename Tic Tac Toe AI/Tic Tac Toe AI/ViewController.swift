//
//  ViewController.swift
//  Tic Tac Toe AI
//
//  Created by Guest User on 2018-11-22.
//  Copyright © 2018 Guest User. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
  // 1
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    // 2
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    
    
    // 3
    let winningCombinations = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
    var playerOneMoves = Set<Int>()
    var playerTwoMoves = Set<Int>()
    var possibleMove = Array<Int>()
    var nextMove:Int? = nil
    var playerTurn = 1
    let allspaces: Set<Int> = [1,2,3,4,5,6,7,8,9]
    
   // 4
    @IBAction func newGameButtonClicked(_ sender: AnyObject) {
        //
        newGame()
    }
    
    // 5
    @IBAction func buttonClicked(_ sender: AnyObject) {
        
        if playerOneMoves.contains(sender.tag) || playerTwoMoves.contains(sender.tag) {
            statusLabel.text = "Space already used!"
            
            
        } else {
            
            if playerTurn % 2 != 0 {
                
                // add space to player move list
              
                playerOneMoves.insert(sender.tag)
                sender.setTitle("O", for: UIControlState.normal)
                statusLabel.text = "Player 2's turn!"
                if isWinner(player: 1) == 0 {
                    
                    let nextMove = playDefense()
                    playerTwoMoves.insert(nextMove)
                    let button = self.view.viewWithTag(nextMove) as! UIButton
                    button.setTitle("X", for: UIControlState.normal)
                     statusLabel.text = "Player 1's turn!"
                    
                    isWinner(player: 2)
                }
                
            }
            playerTurn += 1
            if playerTurn > 9 && isWinner(player: 1) < 1{
                 statusLabel.text = "Draw"
                for index in 1...9 {
                    let button = self.view.viewWithTag(index) as! UIButton
                    button.isEnabled = false
                }
                
            }
            
        }
    }
    
    
    
    
    // 6
    func newGame(){
        // clear Move List
        playerOneMoves.removeAll()
        playerTwoMoves.removeAll()
        
        // change status label and set player turn
        statusLabel.text = "Player 1's turn!"
        playerTurn = 1
        
        // 7 setup tiles
        for index in 1...9 {
            let tile = self.view.viewWithTag(index) as! UIButton
            tile.isEnabled = true
            tile.setTitle("",for: UIControlState.normal) // Normal -> normal, forState -> for
            
            
            
        }
        
    }
    
    // 9
    func isWinner(player: Int) -> Int{
        
        var winner = 0
        var moveList = Set<Int>()
        if player == 1 {
            moveList = playerOneMoves
        } else {
            moveList = playerTwoMoves
        }
        
        // CHECK and see if there are any winning combinations
        for combo in winningCombinations {
            if moveList.contains(combo[0]) && moveList.contains(combo[1]) && moveList.contains(combo[2]) && moveList.count > 2 {
                
                winner = player
                statusLabel.text = "Player \(player) has won the game!"
                for index in 1...9 {
                    let tile = self.view.viewWithTag(index) as! UIButton
                    tile.isEnabled = false
                }
                
            }
        }
        
        
        return winner
    }
    
    // 10
    func playDefense() -> Int{
        
        var possibleLoses = Array<Array<Int>>()
        var possibleWins = Array<Array<Int>>()
        let spacesLeft = allspaces.subtracting(playerOneMoves.union(playerTwoMoves))
        for combo in winningCombinations {
            var count = 0
            
            for play in combo {
                if playerOneMoves.contains(play){
                    count += 1
                }
                if playerTwoMoves.contains(play){
                    count -= 1
                }
                if count == 2 {
                    possibleLoses.append(combo)
                    count = 0
                    
                }
                if count == -2{
                    possibleWins.append(combo)
                    count = 0
                }
            }
        }
        if possibleWins.count > 0 {
            for combo in possibleWins {
                for space in combo {
                    if !(playerOneMoves.contains(space) || playerTwoMoves.contains(space)){
                        
                        return space
                    }
                }
            }
        }
        
        if possibleLoses.count > 0{
            for combo in possibleLoses{
                for space in combo{
                    if !(playerOneMoves.contains(space) || playerTwoMoves.contains(space)){
                        possibleMove.append(space)
                    } /*else{     possibleMove.append(space)
                    }*/
                }
            }
        }
        
        if possibleMove.count > 0 {
            
            nextMove = possibleMove[Int(arc4random_uniform(UInt32(possibleMove.count)))]
            
        }else if allspaces.subtracting(playerOneMoves.union(playerTwoMoves)).count > 0 {
            
           nextMove = spacesLeft[spacesLeft.index(spacesLeft.startIndex, offsetBy: Int(arc4random_uniform(UInt32(spacesLeft.count))))]
        }
        possibleMove.removeAll()
        possibleLoses.removeAll()
        possibleWins.removeAll()
        playerTurn += 1
        return nextMove!
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // 8
        newGame()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

