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
//        QNACollectionView.register(QNACollectionViewCell.self, forCellWithReuseIdentifier: "QNACollectionViewCell")
//        self.QNACollectionView.automaticallyAdjustsScrollIndicatorInsets = false
        self.QNACollectionView.contentInsetAdjustmentBehavior = .never
        
        self.QNACollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func resetCollectionView(){
        guard !(post==nil) else {return}
        post = nil;
        QNACollectionView.reloadData()
    }
    
    @IBAction func curisoityButton(_ sender: Any) {
        
        let curiosityButton = sender as! UIButton
        let cell = curiosityButton.superview?.superview as! QNATableViewCell
        let user = PFUser.current();
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
                var curious_users = post["curious_user"] as! [String]
                if (curious_users.contains((user!.username!))){ // Is Current User Already Clicked
                    let index = curious_users.firstIndex(of: user!.username!)
                    curious_users.remove(at: index!)
                    post["curious_user"] = curious_users
                    post.saveInBackground()
                    self.curiosityButton.setBackgroundImage(UIImage(systemName: "questionmark.circle"), for: .normal)
                    
                }
                else { // Not Yet Clicked
                    curious_users.append(user!.username!)
                    post["curious_user"] = curious_users
                    post.saveInBackground()
                    self.curiosityButton.setBackgroundImage(UIImage(systemName: "questionmark.circle.fill"), for: .normal)
        
                }
//                let table = self.superview as! UITableView
//                table.beginUpdates()
//                table.reloadRows(at: [indexPath], with: .automatic)
//                table.endUpdates()
                self.post!["curious_user"] = post["curious_user"]
                self.curiosityLabel.text = "\(curious_users.count)";
            }
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCollectionView()
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
        if (images != nil){
            let image = images[indexPath[0]] as! PFFileObject
            let imageURL = image.url
            var url = URL(string: imageURL!)
            let height = self.QNACollectionView.bounds.height - self.QNACollectionView.contentInset.top - self.QNACollectionView.contentInset.bottom
            let size = CGSize(width: height , height: height)
            cell.frame.size = size
            let filter = AspectScaledToFillSizeFilter(size: size)
            cell.QNAImageView.af_setImage(withURL: url!, filter: filter)
            cell.QNAImageView.clipsToBounds = true
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size = CGSize(width: 200, height: 200)
        return size
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numofImages
    }
}
