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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
 
    
    
    @IBAction func login(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: self.usernameTextField.text!, password: self.passwordTextField.text!) {
          (user: PFUser?, error: Error?) -> Void in
          if user != nil {
            self.displayAlert(withTitle: "Login Successful", message: "")
          } else {
            self.displayAlert(withTitle: "Error", message: error!.localizedDescription)
          }
        }
    }
    
    func displayAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    
    
    
    @IBAction func register(_ sender: Any) {
        performSegue(withIdentifier: "registerSegue", sender: Any?(nilLiteral: ()))
    }
 
}

