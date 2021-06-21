//
//  ViewController.swift
//  ConnecTING-CTING
//
//  Created by sunhyeok on 2021/06/03.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {

        // allowing user to stay logged in
        var currentUser = PFUser.current()
        
        if currentUser != nil && currentUser?.username != nil{
            self.performSegue(withIdentifier: "logintomenuSegue", sender: Any?.self)
        } else {
          // Show the signup or login screen
        }
        
    }
    
    
    @IBAction func login(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: self.usernameTextField.text!, password: self.passwordTextField.text!) {
          (user: PFUser?, error: Error?) -> Void in
            self.loginIndicator.startAnimating()
          if user != nil {
            self.loginIndicator.stopAnimating()
            self.loginSuccefully()
          } else {
            self.displayAlert(withTitle: "Error", message: error!.localizedDescription)
            self.loginIndicator.stopAnimating()
          }
        }
    }
    
    func loginSuccefully(){
        let alert = UIAlertController(title: "Succesfully login", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {action in self.login()})
        alert.addAction(okAction)
        self.present(alert, animated: true)
        
    }
    
    func login(){
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "logintomenuSegue", sender: Any?.self)
    }
    
    func displayAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {action in self.dismiss(animated: true, completion: nil)})
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    
    @IBAction func register(_ sender: Any) {
        performSegue(withIdentifier: "registerSegue", sender: Any?(nilLiteral: ()))
    }
 
}

