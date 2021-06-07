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

class QuestionViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate ,UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    var currenttag = -1;
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTextView.textColor = .lightGray
        detailsTextView.text = "Type your details / context here..."
        detailsTextView.isScrollEnabled = false
        detailsTextView.autocapitalizationType = .words
        detailsTextView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.numberOfItems(inSection: 1)
        self.collectionView.reloadData()
        
        let width = 294
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        
        // Do any additional setup after loading the view.
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionCollectionViewCell", for: indexPath) as! QuestionCollectionViewCell
        cell.addImageButton.tag = indexPath.section + 10
        return cell
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    @IBAction func addMainbImage(_ sender: UIButton) {
        currenttag = sender.tag;
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }

    @IBAction func deleteImage(_ sender: UIButton!) {
        let cell = sender.superview?.superview as! QuestionCollectionViewCell
        cell.addImageButton.setImage(nil, for: .normal)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 294, height: 294  )
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        let tempButton = self.view.viewWithTag(currenttag) as! UIButton
        tempButton.setImage(scaledImage, for: .normal)        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func post(_ sender: Any) {
        let post = PFObject(className: "posts")
        
        post["author"] = PFUser.current()
        post["caption"] = subjectTextField.text
        post["details"] = detailsTextView.text
//        var images = [PFFileObject?](repeating: nil, count: 6)
//        var index = 0;
//        for i in 1...6{
//            let tempButton = self.view.viewWithTag(i) as? UIButton
//            let imageData = tempButton?.imageView!.image
//            if (imageData != nil){
//                let image = imageData?.pngData()
//                let file = PFFileObject(data: image!)
//                images[index] = file!;
//                index = index + 1;
//            }
//            else{}
//        }
//        post["images"] = images

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



