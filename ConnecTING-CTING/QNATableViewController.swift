//
//  QNATableViewController.swift
//  ConnecTING-CTING
//
//  Created by sunhyeok on 2021/06/05.
//

import UIKit
import Parse


class QNATableViewController: UITableViewController{


    var posts = [PFObject]()

    

    
    @IBAction func tableViewRefresh(_ sender: Any) {
        self.tableView.reloadData()
        getQuery()
        self.refreshControl?.endRefreshing()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        var bounds = UIScreen.main.bounds
        var height = bounds.size.height
        self.tableView.rowHeight = height * 0.4434
        self.tableView.reloadData()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getQuery(){
        let query = PFQuery(className: "posts")
        query.includeKeys(["author","caption","details","images","curious_user","createdAt"])
        query.limit = 1000
        query.findObjectsInBackground{ (post, error)
            in
            if post != nil{
                self.posts = post!
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getQuery()
    }

    @IBAction func questionButton(_ sender: Any) {
        self.performSegue(withIdentifier: "questionSegue", sender: Any?.self)
    }
   

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return posts.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    // post["author"] : PFUser
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[posts.count - indexPath.section - 1]
        let captions = post["caption"]
        let detailss = post["details"]
        let curious_users = post["curious_user"] as! [PFUser]
        let curious_level = curious_users.count
        let cell = tableView.dequeueReusableCell(withIdentifier: "QNATableViewCell") as! QNATableViewCell
        let user = PFUser.current() as! PFUser;
        let images = post.object(forKey: "images") as! NSArray // Array of images
        
        cell.caption.text = (captions as! String)
        cell.details.text = (detailss as! String)
        cell.curiosityLabel.text = "\(curious_level)"
        cell.post = post;
        cell.objectID = post.objectId
        cell.table_indexPath = indexPath;
        cell.numofImages = images.count  // used for QNATableViewCell number of sections.
        cell.timeLabel.text = timeConverter(time: post.createdAt!.timeIntervalSinceNow)

        
        // Already Liked??
        if (curious_users.contains(where: {$0.username == user.username})){
            cell.curiosityButton.setBackgroundImage(UIImage(systemName: "questionmark.circle.fill"), for: .normal)
        } else {
            cell.curiosityButton.setBackgroundImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "QNADetailsSegue", sender: Any?.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        if segue.identifier == "QNADetailsSegue" {
            let post = posts[posts.count - indexPath!.section - 1]
            let destination_ViewController = segue.destination as! QNADetailsViewController
            destination_ViewController.post = post
            destination_ViewController.time = timeConverter(time: post.createdAt!.timeIntervalSinceNow)
        }
    }
    
    
    // double type number into corresponding minutes/ hours/ or days
    func timeConverter(time : Double) -> String{
        var new_time = time
        if (time < 0){ // timeInterval is negative
            new_time = new_time * -1.0 // to make positive double number
        }
        
        if ( (new_time / 60) < 1 ){
            return ("Just Posted!")
        } else if ( (new_time / 60 ) < 60){
            new_time = new_time / 60
            new_time.round()
            let output = String(format: "%.0f", new_time)
            return ("Posted \(output) minutes ago")
        } else if ( ((new_time / 60) >= 60) && ((new_time / 3600) < 24) ){
            new_time = new_time / 3600
            new_time.round()
            let output = String(format: "%.0f", new_time)
            return ("Posted \(output) hours ago")
        } else if ( ((new_time / 3600) >= 24) )  {
            new_time = new_time / 3600
            new_time = new_time / 24
            new_time.round()
            let output = String(format: "%.0f", new_time)
            return ("Posted \(output) days ago")
        } else {
            return ("WAKKKKK")
        }
    }
    


}
