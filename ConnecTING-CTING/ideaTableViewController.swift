//
//  ideaTableViewController.swift
//  ConnecTING-CTING
//
//  Created by sunhyeok on 2021/06/21.
//

import UIKit
import Parse
import AlamofireImage

class ideaTableViewController: UITableViewController {
    var posts : [PFObject] = []
    var liked_posts : [String] = [] // [ObjectID of Posts which is type of String]
    var number_of_posts : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch_Liked_Posts()
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
    override func viewDidAppear(_ animated: Bool) {
        fetch_Liked_Posts()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return number_of_posts
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let post = posts[posts.count - indexPath.section - 1]
        let captions = post["caption"]
        let detailss = post["details"]
        let curious_users = post["curious_user"] as! [PFUser]
        let curious_level = curious_users.count
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdeaTableViewCell") as! IdeaTableViewCell
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
        if (curious_users.contains(where: {$0.objectId == user.objectId})){
            cell.curiosityButton.setBackgroundImage(UIImage(systemName: "questionmark.circle.fill"), for: .normal)
        } else {
            cell.curiosityButton.setBackgroundImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        }
        return cell
    }

    
    
    func fetch_Liked_Posts(){
        let user = PFUser.current() as! PFUser
        self.liked_posts = user["Liked_Posts"] as! [String]
        self.number_of_posts = self.liked_posts.count
        
        for i in 0...self.number_of_posts - 1 {
            let postId = self.liked_posts[i] as? String
            let post = try? PFQuery.getObjectOfClass("posts", objectId: postId!) as? PFObject
            self.posts.append(post!)
        }
        print(self.posts)
        
    }
    
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
    

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
