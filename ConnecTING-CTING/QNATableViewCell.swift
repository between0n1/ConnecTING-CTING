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
    
    @IBOutlet weak var QNACollectionView: UICollectionView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var details: UILabel!
    var view_width : CGFloat = UIScreen.main.bounds.width * (0.6)
    var post : Any? = nil
    var numofImages : Int = 0;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.QNACollectionView.delegate = self
        self.QNACollectionView.dataSource = self
//        QNACollectionView.register(QNACollectionViewCell.self, forCellWithReuseIdentifier: "QNACollectionViewCell")
//        self.QNACollectionView.automaticallyAdjustsScrollIndicatorInsets = false
//        self.QNACollectionView.contentInsetAdjustmentBehavior = .never
        self.QNACollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    
    func resetCollectionView(){
        guard !(post==nil) else {return}
        post = nil;
        QNACollectionView.reloadData()
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
            cell.frame.size = CGSize(width: view_width, height: view_width)
            cell.QNAImageView.af_setImage(withURL: url!)
            cell.QNAImageView.clipsToBounds = true
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size = CGSize(width: view_width, height: view_width)
        return size
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numofImages
    }
}
