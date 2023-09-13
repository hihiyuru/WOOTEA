//
//  CategoryCollectionViewCell.swift
//  WOOTEA
//
//  Created by 徐于茹 on 2023/9/13.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var CategoryButtton: UIButton!
    @IBOutlet weak var CategoryButtonWidthNSLayoutConstraint: NSLayoutConstraint!
    static let width = floor((UIScreen.main.bounds.width - 10 - 10 * 2) / 2 )
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
        CategoryButtonWidthNSLayoutConstraint.constant = Self.width
        }
}
