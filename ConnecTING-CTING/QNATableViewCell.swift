//
//  QNATableViewCell.swift
//  ConnecTING-CTING
//
//  Created by sunhyeok on 2021/06/06.
//

import UIKit
import Parse
import AlamofireImage

class QNATableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    

    
    
    @IBOutlet weak var QNACollectionView: UICollectionView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var details: UILabel!
    var post : (Any)? = nil;
    var numofImages : Int = 0;

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.QNACollectionView.delegate = self
        self.QNACollectionView.dataSource = self
//        QNACollectionView.register(QNACollectionViewCell.self, forCellWithReuseIdentifier: "QNACollectionViewCell")
        self.QNACollectionView.reloadData()
        
        let layout = QNACollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 294, height: 294)
    
        
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
        let image = images.object(at: indexPath[0]) as! PFFileObject
        let imageURL = image.url
        var url = URL(string: imageURL!)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QNACollectionViewCell", for: indexPath) as! QNACollectionViewCell
        print(url!)
        cell.QNAImageView.af_setImage(withURL: url!)
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return numofImages
    }

    

}
