//
//  QNATableViewCell.swift
//  ConnecTING-CTING
//
//  Created by sunhyeok on 2021/06/06.
//

import UIKit
import Parse
import AlamofireImage

class QNATableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var curiosityButton: UIButton!
    @IBOutlet weak var curiosityLabel: UILabel!
    @IBOutlet weak var QNACollectionView: UICollectionView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var details: UILabel!
    
    var view_width : CGFloat = UIScreen.main.bounds.width * (0.6)
    var post : PFObject? = nil
    var numofImages : Int = 0;
    var objectID : String? = nil;
    var table_indexPath : Any? = nil;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.QNACollectionView.delegate = self
        self.QNACollectionView.dataSource = self
        self.QNACollectionView.contentInsetAdjustmentBehavior = .never
        self.QNACollectionView.reloadData()
        self.QNACollectionView.bounds.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    
    
    @IBAction func curisoityButton(_ sender: Any) {
        
        let curiosityButton = sender as! UIButton
        let cell = curiosityButton.superview?.superview as! QNATableViewCell
        let user = PFUser.current() as! PFUser;
        let id = user.objectId

        let indexPath = table_indexPath as! IndexPath
        let query = PFQuery(className: "posts")
        query.includeKey("curious_user")
        query.getObjectInBackground(withId: self.objectID!){ [self]
            (post : PFObject?, error: Error?)
            in
            if let error = error{
                print(error.localizedDescription)
            }
            else if let post = post {
                var curious_users = post["curious_user"] as! [PFUser]
                var liked_posts = user["Liked_Posts"] as! [String]

                if (curious_users.contains(where: {$0.username == user.username})){ // Is Current User Already Clicked
                    let index = curious_users.firstIndex(where: {$0.username == user.username})
                    curious_users.remove(at: index!)
                    post["curious_user"] = curious_users
                    post.saveInBackground()
                    self.curiosityButton.setBackgroundImage(UIImage(systemName: "questionmark.circle"), for: .normal)

                    let liked_post_index = liked_posts.firstIndex(of: post.objectId!)
                    liked_posts.remove(at: liked_post_index!)
                    user["Liked_Posts"] = liked_posts
                    user.saveInBackground()

                }
                else { // Not Yet Clicked
                    curious_users.append(user)
                    post["curious_user"] = curious_users
                    post.saveInBackground()
                    self.curiosityButton.setBackgroundImage(UIImage(systemName: "questionmark.circle.fill"), for: .normal)

                    liked_posts.append(post.objectId!)
                    user["Liked_Posts"] = liked_posts
                    user.saveInBackground()
                }
                self.post!["curious_user"] = post["curious_user"]
                self.curiosityLabel.text = "\(curious_users.count)";
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCollectionView()
    }
    
    func resetCollectionView(){
        guard !(post==nil) else {return}
        post = nil;
        self.QNACollectionView.contentInset.left = 10
        self.QNACollectionView.contentInset.right = 10
        QNACollectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postObject = post as! PFObject
        let images = postObject.object(forKey: "images") as! NSArray
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QNACollectionViewCell", for: indexPath) as! QNACollectionViewCell
        numofImages = images.count
        cell.QNAImageView.image = nil
        if (images != []){
            let image = images[indexPath[0]] as! PFFileObject
            let imageURL = image.url
            var url = URL(string: imageURL!)
            let height = self.QNACollectionView.bounds.height - self.QNACollectionView.contentInset.top - self.QNACollectionView.contentInset.bottom
            let size = CGSize(width: height , height: height)
            cell.frame.size = size
            let filter = AspectScaledToFillSizeFilter(size: size)
            cell.QNAImageView.af_setImage(withURL: url!, filter: filter)
            cell.QNAImageView.clipsToBounds = true
            
            if ( numofImages == 1 ){ // align the image at center if only one image i
                self.QNACollectionView.contentInset.left = ((self.QNACollectionView.bounds.size.width - cell.bounds.size.width) / 2)
                self.QNACollectionView.contentInset.right = ((self.QNACollectionView.bounds.size.width - cell.bounds.size.width) / 2)
            }
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = self.QNACollectionView.bounds.height - self.QNACollectionView.contentInset.top - self.QNACollectionView.contentInset.bottom
        let size = CGSize(width: width, height: width)
        return size
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numofImages
    }
}
