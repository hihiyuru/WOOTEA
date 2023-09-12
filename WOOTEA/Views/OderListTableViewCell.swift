//
//  OderListTableViewCell.swift
//  WOOTEA
//
//  Created by 徐于茹 on 2023/9/12.
//

import UIKit

class OderListTableViewCell: UITableViewCell {

    @IBOutlet weak var DrinkLabel: UILabel!
    @IBOutlet weak var UserLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var BgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
