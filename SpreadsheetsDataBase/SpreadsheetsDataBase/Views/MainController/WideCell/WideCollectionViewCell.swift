//
//  WideCollectionViewCell.swift
//  SpreadsheetsDataBase
//
//  Created by Fedii Ihor on 18.06.2022.
//

import UIKit

class WideCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var typeImageView: UIImageView!
    @IBOutlet private weak var itemLabel: UILabel!
    @IBOutlet weak var openNextFolderlabel: UILabel!
    @IBOutlet weak var pointerLabel: UILabel!
    
    static let id = "WideCollectionViewCell"
    static func nib() -> UINib {
        return UINib.init(nibName: WideCollectionViewCell.id, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        typeImageView.contentMode = .scaleAspectFit
        contentView.backgroundColor = .tertiarySystemFill
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
    }
    
    open func setupCell(by item: SheetItem) {
        typeImageView.image = (item.type == .d ?
                               UIImage(systemName: "folder.circle") :
                                UIImage(systemName: "doc.richtext.fill"))
        
        itemLabel.text = item.content
        itemLabel.textColor = (item.type == .d ? .systemBlue : .black)
        pointerLabel.alpha = (item.type == .d ? 1.0 : 0.0)
    }
    
    

}
