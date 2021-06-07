//
//  QNATableViewCell.swift
//  ConnecTING-CTING
//
//  Created by sunhyeok on 2021/06/06.
//

import UIKit

class QNATableViewCell: UITableViewCell {

    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var details: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
