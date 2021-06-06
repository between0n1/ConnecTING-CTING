//
//  QuestionViewController.swift
//  Pods
//
//  Created by sunhyeok on 2021/06/05.
//

import UIKit
import Parse

class QuestionViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTextView.textColor = .lightGray
        detailsTextView.text = "Type your details / context here..."
        detailsTextView.isScrollEnabled = false
        detailsTextView.autocapitalizationType = .words
        detailsTextView.delegate = self
        
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func post(_ sender: Any) {
        let post = PFObject(className: "posts")
        post["author"] = PFUser.current()
        post["caption"] = subjectTextField.text
        post["details"] = detailsTextView.text
        post.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                self.displayAlert(withTitle: "Succefully posted!", message: "Succefully posted!", success: true)
            } else {
                self.displayAlert(withTitle: "Failed to post", message: error!.localizedDescription, success: false)
            }
        }
    }
    
    
    func displayAlert(withTitle title: String, message: String, success: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {action in if success {self.dismiss(animated: true, completion: nil)}})
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        if detailsTextView.textColor == .lightGray{
            detailsTextView.text = nil
            detailsTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        if detailsTextView.text.isEmpty || detailsTextView.text == "" {
            detailsTextView.textColor = .lightGray
            detailsTextView.text = "Type your thoughts here..."
        }
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
