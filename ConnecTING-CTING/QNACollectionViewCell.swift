//
//  QNACollectionViewCell.swift
//  ConnecTING-CTING
//
//  Created by sunhyeok on 2021/06/08.
//

import UIKit
import Parse
import AlamofireImage
class QNACollectionViewCell: UICollectionViewCell {
    
    var posts = [PFObject]()
    
    @IBOutlet weak var QNAImageView: UIImageView!
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
