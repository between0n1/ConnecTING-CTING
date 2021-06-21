//
//  RegisterViewController.swift
//  ConnecTING-CTING
//
//  Created by sunhyeok on 2021/06/03.
//

import UIKit
import Parse


class RegisterViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var reenterpasswordTextField: UITextField!
    @IBOutlet weak var indicatorsignup: UIActivityIndicatorView!
    @IBOutlet weak var password1error: UIImageView!
    @IBOutlet weak var password2error: UIImageView!
    @IBOutlet weak var usernameerror: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func register(_ sender: Any) {
        let user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        
        /*
         user.email = "email@example.com"
                                            // other fields can be set just like with PFObject
           user["phone"] = "415-392-0202"
        */
        self.indicatorsignup.startAnimating()
        
        if (self.isusernameValid(username: self.usernameTextField.text!) == false){
            self.displayAlert(withTitle: "Error", message: "Your username includes invalid characters")
            self.usernameerror.backgroundColor = .red
            }
        else if (self.ispasswordDifferent(password1: self.passwordTextField.text!, password2: self.reenterpasswordTextField.text!)){
            self.usernameerror.backgroundColor = nil // to indicate that user entered valid username
            self.password1error.backgroundColor = .red
            self.password2error.backgroundColor = .red
            self.displayAlert(withTitle: "Error", message: "You entered different passwords")
            }
        else{
            user.signUpInBackground {(succeeded: Bool, error: Error?) -> Void in
                self.indicatorsignup.stopAnimating()
                if let error = error {
                    self.displayAlert(withTitle: "Error", message: error.localizedDescription)
                    }
                else {
                    self.usernameerror.backgroundColor = nil
                    self.password1error.backgroundColor = nil
                    self.password2error.backgroundColor = nil
                    self.displayAlert()
                    }
                }
        }
        
        
        
        
    }
    
    func isusernameValid(username: String) -> Bool{
        for chara in username {
            let char = Int(chara.unicodeScalars.first!.value)
            if ( ((char >= 48) && (char <= 57)) || ((char >= 65) && (char <= 90)) || ((char >= 97) && (char <= 122)) ){
            }
            else{
                return false
            }
        }
        return true
    }
    
    func ispasswordDifferent(password1 : String, password2: String) -> Bool{
        return (password1 != password2)
    }
    
    func displayAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func displayAlert() { // will be used when user succefully created an account.
        let alert = UIAlertController(title: "Success", message: "Successfully created your account!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {action in self.dismiss(animated: true, completion: nil)})
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
