//
//  QNADetailsViewController.swift
//  ConnecTING-CTING
//
//  Created by sunhyeok on 2021/06/21.
//

import UIKit
import Parse
import AlamofireImage



class QNADetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var curiosityLabel: UILabel!
    @IBOutlet weak var QNADetailsCollectionView: UICollectionView!
    
    
    var post : PFObject!
    var time : String!
    var images : NSArray!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.QNADetailsCollectionView.delegate = self
        self.QNADetailsCollectionView.dataSource = self
        detailsLabel.sizeToFit()
        
        if post != nil{
            let author = post["author"] as! PFUser
            let username = author.username as! String
            let title = post["caption"] as! String
            let details = post["details"] as! String
            images = post["images"] as! NSArray
            let curious_user = post["curious_user"] as! NSArray
            
            self.timeLabel.text = time
            self.authorLabel.text = "by \(username)"
            self.titleLabel.text = title
            self.detailsLabel.text = details
            self.curiosityLabel.text = "\(curious_user.count) users are also interested in this post."
            
            
            
            if title == nil{
                self.titleLabel.text = "No Title"
            }
            if details == nil{
                self.detailsLabel.text = "No Details"
            }
            
            
            // navigation Item Image
            let titleView =  UIView()
            let CTing_logo = UIImage(named: "CTing_Logo_1920")
            let logo_imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height:45))
            logo_imageView.center = titleView.center
            logo_imageView.image = CTing_logo
            logo_imageView.contentMode = .scaleAspectFit
            titleView.addSubview(logo_imageView)
            self.navigationItem.titleView = titleView
            
            
            

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QNADetailsCollectionViewCell", for: indexPath) as! QNADetailsCollectionViewCell
        
        
        let postObject = post as! PFObject
        
        if (images != []){
            let image = images[indexPath[0]] as! PFFileObject
            let imageURL = image.url
            var url = URL(string: imageURL!)
            let height = self.QNADetailsCollectionView.bounds.height
            let size = CGSize(width: height , height: height)
            cell.frame.size = size
            let filter = AspectScaledToFillSizeFilter(size: size)
            cell.QNADetailsImageView.af_setImage(withURL: url!, filter: filter)
            cell.QNADetailsImageView.clipsToBounds = true
        }
        
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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
