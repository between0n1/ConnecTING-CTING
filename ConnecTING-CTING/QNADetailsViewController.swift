//
//  QNADetailsViewController.swift
//  ConnecTING-CTING
//
//  Created by sunhyeok on 2021/06/21.
//

import UIKit
import Parse
import Alamofire



class QNADetailsViewController: UIViewController {
    // posts = [PFObject]()
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var curiosityLabel: UILabel!
    
    var post : PFObject!
    var time : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        
        
        
        if post != nil{
            let author = post["author"] as! PFUser
            let username = author.username as! String
            let title = post["caption"] as! String
            let details = post["details"] as! String
            let images = post["images"] as! NSArray
            let curious_user = post["curious_user"] as! NSArray
            
            self.timeLabel.text = time
            self.authorLabel.text = "by \(username)"
            self.titleLabel.text = title
            self.detailsLabel.text = details
            self.curiosityLabel.text = "\(curious_user.count) users are also interested in this post."
            
            let titleView =  UIView()
            
            let CTing_logo = UIImage(named: "CTing_Logo_1920")
            let logo_imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height:60))
            logo_imageView.center = titleView.center
            logo_imageView.image = CTing_logo
            logo_imageView.contentMode = .scaleAspectFit
            titleView.addSubview(logo_imageView)
            self.navigationItem.titleView = titleView
            
            
            
        }
        
        // Do any additional setup after loading the view.
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
