//
//  TableCell.swift
//  SpreadsheetsDataBase
//
//  Created by Fedii Ihor on 30.06.2022.
//

import UIKit

class TableCell: UITableViewCell {
    
    static let id = "TableCell"
    static func nib() -> UINib {
        return UINib(nibName: TableCell.id, bundle: nil)
    }
    
    @IBOutlet private weak var typeImageView: UIImageView!
    @IBOutlet private weak var itemLabel: UILabel!
    @IBOutlet weak var pointerLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        typeImageView.contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
        backgroundColor = .tertiarySystemFill
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.cornerRadius = 5
        clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
