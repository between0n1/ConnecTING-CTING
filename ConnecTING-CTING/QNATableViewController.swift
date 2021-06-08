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

    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = 362
        let screen = UIScreen.main.bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "posts")
        query.includeKeys(["author","caption","details","images"])
        query.limit = 20
        query.findObjectsInBackground{ (post, error)
            in
            if post != nil{
                self.posts = post!
                self.tableView.reloadData()
            }
        }
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[posts.count - indexPath.section - 1]
        let captions = post["caption"]
        let detailss = post["details"]
        let cell = tableView.dequeueReusableCell(withIdentifier: "QNATableViewCell") as! QNATableViewCell
        cell.caption.text = (captions as! String)
        cell.details.text = (detailss as! String)
        cell.post = post;
        let post_forcolelctionview = post.object(forKey: "images") as! NSArray
        cell.numofImages = post_forcolelctionview.count
        
        return cell
    }
    


}
