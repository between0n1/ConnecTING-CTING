//
//  QuestionViewController.swift
//  Pods
//
//  Created by sunhyeok on 2021/06/05.
//

import UIKit
import Parse
import AlamofireImage

/*
 tags in (10...20) are addImage Buttons
 
 */

extension UITextView{
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}

extension UITextField{
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}

class QuestionViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate ,UINavigationControllerDelegate  {

    @IBOutlet weak var QuestionImageView: QuestionImageView!
    @IBOutlet weak var AddImageButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var postActivityIndicator: UIActivityIndicatorView!
    let MaxImage : Int = 10
    var current_button = UIButton() // for imagePickerController
    let view_width = (UIScreen.main.bounds.width * 0.4538)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTextView.textColor = .lightGray
        detailsTextView.text = "Description"
        detailsTextView.isScrollEnabled = true
        detailsTextView.autocapitalizationType = .words
        detailsTextView.delegate = self
        detailsTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        titleTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        setImageViews()
        self.postActivityIndicator.isHidden = true


    }
    @objc func tapDone(sender: Any){
        self.view.endEditing(true)
    }
    
    func setImageViews(){
        for i in 100...105{ // from 100 to 105 are QuestionImageViews
            let my_view = view.viewWithTag(i) as! QuestionImageView
            
            my_view.frame.size.width = view_width
            my_view.frame.size.height = view_width
            my_view.layer.borderWidth = 1
            my_view.layer.borderColor = UIColor.blue.cgColor
            my_view.layer.cornerRadius = 10
            var imageButton = my_view.subviews[0] as! UIButton
            imageButton.frame.size = CGSize(width: view_width, height: view_width)
            imageButton.layer.cornerRadius = 10
            imageButton.clipsToBounds = true
        }
    }

    
    @IBAction func deleteImage(_ sender: UIButton!) {
        let imageView = sender.superview as! QuestionImageView
        let imageButton = sender.superview?.subviews[0] as! UIButton
        imageButton.setBackgroundImage(nil, for: .normal)
        imageButton.setImage(UIImage(systemName: "arrow.up.bin.fill"), for: .normal)
        imageView.Image = nil
    }
    
    @IBAction func addImage(_ sender: UIButton!) {
        
        current_button = sender as! UIButton
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        
        
        var alert = UIAlertController(title: "Choosee Image", message: nil, preferredStyle: .actionSheet)
        
        let chooseCamera = UIAlertAction(title: "Camera", style: .default) { UIAlertAction in
            Camera()
        }
        
        let chooseGallary = UIAlertAction(title: "Gallery", style: .default) { UIAlertAction in
            CameraRoll()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { UIAlertAction in alert.dismiss(animated: true, completion: nil)
        }
        
        
        alert.addAction(chooseCamera)
        alert.addAction(chooseGallary)
        alert.addAction(cancel)

        
        present(alert,animated: true,completion: nil)
        
        
        func Camera(){
            if (UIImagePickerController.isSourceTypeAvailable(.camera)){
                picker.sourceType = .camera
                alert.dismiss(animated: true, completion: nil)
                present(picker, animated: true, completion: nil)
            }
            else{
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
        func CameraRoll(){
            picker.sourceType = .photoLibrary
            alert.dismiss(animated: true, completion: nil)
            present(picker, animated: true, completion: nil)
        }
        

        
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: view_width, height: view_width)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        current_button.setBackgroundImage(scaledImage, for: .normal)
        current_button.setImage(nil, for: .normal)
        let theView = current_button.superview as! QuestionImageView
        theView.Image = image; // each View has the data of image before scaled so that the server can receive unscaled image for later use
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func post(_ sender: UIButton) {
        self.postActivityIndicator.isHidden = false
        self.postActivityIndicator.startAnimating()
        sender.isEnabled = false
        let post = PFObject(className: "posts")
        let details = detailsTextView.text
        let title = titleTextField.text
        if (title != "" && title != nil){
            if ( details != nil && details != "Description"){
                var images = [PFFileObject?]()
                for i in 100...105{
                    let current_view = self.view.viewWithTag(i) as! QuestionImageView
                    if (current_view.Image != nil){
                        let imageData = current_view.Image as! UIImage;
                        let image = imageData.pngData()
                        let imageFile = PFFileObject(data: image!)
                        images.append(imageFile!)
                    }
                }
                if (images.isEmpty){
                    displayAlert(withTitle: "No images uploaded", message: "Please upload at least one image", success: false)
                    sender.isEnabled = true
                }
                else{
                    post["author"] = PFUser.current()
                    post["caption"] = title
                    post["details"] = details
                    post["curiosity"] = 0;
                    post["curious_user"] = [] as [PFUser]
                    post.setObject(images, forKey: "images")
                    post.saveInBackground { (succeeded, error)  in
                        if (succeeded) {
                            self.displayAlert(withTitle: "Succefully posted!", message: "Succefully posted!", success: true)
                            sender.isEnabled = true
                        } else {
                            self.displayAlert(withTitle: "Failed to post", message: error!.localizedDescription, success: false)
                            sender.isEnabled = true
                        }
                    }
                }
            }
            else{
                displayAlert(withTitle: "No details entered", message: "Please enter details", success: false)
                sender.isEnabled = true
            }
        }
        else{
            displayAlert(withTitle: "No title entered", message: "Please enter title", success: false)
            sender.isEnabled = true
        }
        
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func displayAlert(withTitle title: String, message: String, success: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {action in if success {self.dismiss(animated: true, completion: nil)}
        else{
            self.postActivityIndicator.stopAnimating()
            self.postActivityIndicator.isHidden = true
        }
        })
        
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
            detailsTextView.text = "Description"
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



