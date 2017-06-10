//
//  ViewController.swift
//  WarGame
//
//  Created by a on 5/22/17.
//  Copyright © 2017 War Project Xcode. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase



class ViewController: UIViewController {

    //Link labels and buttons
    @IBOutlet weak var loginRegister: UISegmentedControl!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var enterButton: UIButton!
    
    var ref: DatabaseReference!
    
    //Boolean for if the user is logged in or not
    var isLogin:Bool = true
    var existsCheck:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        //Make enter button more visible
        enterButton.layer.borderWidth = 0.4
        enterButton.layer.borderColor = UIColor.red.cgColor
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginControl(_ sender: UISegmentedControl) {
        isLogin = !isLogin
        
        //Assign button and table text based on which side of the button is tapped
        if isLogin{
            loginLabel.text = "Login"
            enterButton.setTitle("Login", for: .normal)
        }
        else {
            loginLabel.text = "Register"
            enterButton.setTitle("Register", for: .normal)
        }
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        // TODO: Do some form validation on the email and password
    
        
        if let email = emailField.text, let pass = passwordField.text {
            
            // Check if it's sign in or register
            if isLogin {
                // Sign in the user with Firebase
                Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                    
                    // Check that user isn't nil
                    if let u = user {
                        // User is found, go to home screen, pass user ID to GameViewController
                        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
                        myVC.stringPassed = u.uid
                        self.navigationController?.pushViewController(myVC, animated: true)
                        
                    }
                    else {
                        //Error alert if user is not found, or username/password is incorrect
                        let alertController = UIAlertController(title: "Error!", message: "Invalid username/password", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                })
                
            }
            else {
                // Register the user with Firebase
                
                
                Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in

                    // Check that user isn't nil
                    if let u = user {
                        // User is found
                        
                        var w:String = "0"
                        var l:String = "0"
                        
                        //create win/loss states for the new user, set them to 0
                        self.ref?.child(u.uid).child("wins").setValue(w)
                        self.ref?.child(u.uid).child("losses").setValue(l)
                    }
                    else {
                        // Error: blank fields/user already exists, shows popup message
                        if (!(self.emailField.hasText) || !(self.passwordField.hasText )) {
                        
                        let alertController = UIAlertController(title: "Error!", message: "One or more fields is blank or user already exists!", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                            self.existsCheck = true
                          
                        }

                        
                    }
                })
                
            }
            
        }

    }
   
  

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Dismiss keyboard
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
}


