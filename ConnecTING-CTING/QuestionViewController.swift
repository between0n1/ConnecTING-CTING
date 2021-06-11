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

//public class Node{
//    var prev: Node?
//    var next: Node?
//    var image:  PFFileObject?
//    init() {
//        prev = nil
//        next = nil
//        image = nil
//    }
//    init(prev: Node, next: Node, image: PFFileObject) {
//        self.prev = prev
//        self.next = next
//        self.image = image
//    }
//    init(image: PFFileObject) {
//        self.image = image
//    }
//}
//
//public class List{
//    private var head: Node?
//    public var isEmpty: Bool{
//        return head == nil
//    }
//    public var first: Node?{
//        return head
//    }
//}

class QuestionViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate ,UINavigationControllerDelegate  {

    @IBOutlet weak var QuestionImageView: QuestionImageView!
    @IBOutlet weak var AddImageButton: UIButton!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    let MaxImage : Int = 10
//    var images = Array(repeating: nil, count: 6)
    var current_button = UIButton() // for imagePickerController
    
    let view_width = (UIScreen.main.bounds.width * 0.4538)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTextView.textColor = .lightGray
        detailsTextView.text = "Type your details / context here..."
        detailsTextView.isScrollEnabled = true
        detailsTextView.autocapitalizationType = .words
        detailsTextView.delegate = self
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
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        current_button = sender as! UIButton

        present(picker, animated: true, completion: nil)
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
    
    
    @IBAction func post(_ sender: Any) {
        let post = PFObject(className: "posts")
        
        post["author"] = PFUser.current()
        post["caption"] = subjectTextField.text
        post["details"] = detailsTextView.text
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
        post.setObject(images, forKey: "images")
        post.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                self.displayAlert(withTitle: "Succefully posted!", message: "Succefully posted!", success: true)
            } else {
                self.displayAlert(withTitle: "Failed to post", message: error!.localizedDescription, success: false)
            }
        }
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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



