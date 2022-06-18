//
//  SquareCollectionViewCell.swift
//  SpreadsheetsDataBase
//
//  Created by Fedii Ihor on 18.06.2022.
//

import UIKit

class SquareCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var typeImageView: UIImageView!
    @IBOutlet private weak var itemLabel: UILabel!
    
    static let id = "SquareCollectionViewCell"
    static func nib() -> UINib {
        return UINib.init(nibName: SquareCollectionViewCell.id, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        typeImageView.contentMode = .scaleAspectFit
        
        contentView.backgroundColor = .secondarySystemFill
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
    
    open func setupCell(by item: SheetItem) {
        typeImageView.image = (item.type == .d ?
                               UIImage(systemName: "folder.circle") :
                                UIImage(systemName: "doc.richtext.fill"))
        
        itemLabel.text = item.content
    }

}
