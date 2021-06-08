//
//  QuestionCollectionViewCell.swift
//  ConnecTING-CTING
//
//  Created by sunhyeok on 2021/06/07.
//

import UIKit

class QuestionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var deleteImageButton: UIButton!
    override func prepareForReuse() {
        super.prepareForReuse()
        addImageButton.setImage(nil, for: .normal)
    }
    
}
