//
//  DrinkTableViewCell.swift
//  WOOTEA
//
//  Created by 徐于茹 on 2023/8/31.
//

import UIKit

class DrinkTableViewCell: UITableViewCell {

    @IBOutlet weak var PicImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ColdPriceLabel: UILabel!
    @IBOutlet weak var HotPriceLabel: UILabel!
    @IBOutlet weak var HotImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
