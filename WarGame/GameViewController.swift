//
//  GameViewController.swift
//  WarGame
//
//  Created by a on 5/24/17.
//  Copyright © 2017 War Project Xcode. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class GameViewController: UIViewController {
    
    //Variables to retrieve user ID from ViewController
    var stringPassed = ""
    var passUserID = ""

    //Link labels with view controller
    @IBOutlet weak var leftCard: UIImageView!
    @IBOutlet weak var rightCard: UIImageView!
    @IBOutlet weak var playerScore: UILabel!
    @IBOutlet weak var CPUscore: UILabel!
    @IBOutlet weak var idLabel: UILabel!

    //Prepare variables to monitor wins/losses, get wins/losses from firebase and calculate the win/loss ratio
    var ref: DatabaseReference!
    var getData =  ""
    var databaseHandle:DatabaseHandle?
    

    
    var winsCount = 0
    var lossesCount = 0
    var totalGames = 0
    
    var getWins =  ""
    var getLosses =  ""
    
    //Set score counters to 0, make an array of all cards to be played
    var leftscorecount = 0
    var rightscorecount = 0
    
    let cards = ["card2","card3","card4","card5","card6","card7","card8","card9","card10","jack","queen","king","ace"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assign user ID to a variable upon loading the game screen
        passUserID = stringPassed
        
        //Retrieve wins/losses from previous games from firebase
        ref = Database.database().reference().child(passUserID)
        
        
        
        
        ref?.observe(.value, with: { (snapshot) in
            
            //Convert the info of the data into a string variable
            if let getData = snapshot.value as? [String:Any] {
                
                let wins = getData["wins"] as? String
                let losses = getData["losses"] as? String
                
                self.getWins = (wins)!
                self.getLosses = losses!
                

            }
        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }

    @IBAction func dealTapped(_ sender: UIButton) {
        
        //Randomize a number, pick a card from the cardNames array to display
        let leftNumber = Int(arc4random_uniform(13))
        let rightNumber = Int(arc4random_uniform(13))
        
        leftCard.image = UIImage(named: cards[leftNumber])
        rightCard.image = UIImage(named: cards[rightNumber])
        
        
        //Add count respectively to each side based on the ranking of card that is drawn
        if leftNumber > rightNumber{
            leftscorecount += 1
            playerScore.text = String(leftscorecount)
        }
        else if leftNumber == rightNumber {
            
        }
        else{
            rightscorecount += 1
           CPUscore.text = String(rightscorecount)
        }
        
        //If player wins
        if leftscorecount == 3
        {
    
            winsCount += 1
            
            //ref?.child("Wins").childByAutoId().setValue(wins)
            
            //message of victory
            let alertController = UIAlertController.init(title: "War!!", message: "You Win!", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction.init(title: "End Game", style: .default, handler: { (action) in self.test() }))
            
            self.present(alertController, animated: true)
            {
                
            }
        }
            //If CPU wins
        else if rightscorecount == 3 {
            
            lossesCount += 1
            
            //ref?.child("Losses").childByAutoId().setValue(wins)
            
            //message of defeat
            let alertController = UIAlertController.init(title: "War!!", message: "You Lose!", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction.init(title: "End Game", style: .default, handler: { (action) in self.test() }))
            
            self.present(alertController, animated: true)
            {
                
            }
            
        }
        
        
    }
    func test() {
        //set labels and scores back to zero to start a new game
        leftscorecount = 0
        playerScore.text = String(leftscorecount)
        
        rightscorecount = 0
        CPUscore.text = String(rightscorecount)
        
    }

    @IBAction func statsTapped(_ sender: UIButton) {
        
        //Calculate total games played per category, and win percentage
        totalGames = Int(getWins)! + Int(getLosses)! + winsCount + lossesCount
      
        //Prep for calculating wins/loss numbers and ratios
       var numerator = Int(getWins)! + winsCount
        var totalLosses = Int(getLosses)! + lossesCount
     
       var winPercentage = Double(numerator) / Double(totalGames)
        
        var finalOutput = Int(100 * winPercentage)
        
        //update values
        
        
        ref?.updateChildValues(["wins": numerator])
        ref?.updateChildValues(["losses": totalLosses])
        
       //Display message of win/loss ratio
        var messageOutput = "Your win:loss ratio is " + String(finalOutput) + "%"
        
        let alertController = UIAlertController.init(title: "War!!", message: messageOutput, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction.init(title: "Dismiss", style: .default, handler: { (action) in self.test() }))
        
        self.present(alertController, animated: true)
        {
            
        }
        
    

    }
}
