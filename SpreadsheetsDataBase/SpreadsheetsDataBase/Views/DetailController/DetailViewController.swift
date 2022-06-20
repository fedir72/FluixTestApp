//
//  DetailViewController.swift
//  SpreadsheetsDataBase
//
//  Created by Fedii Ihor on 19.06.2022.
//

import UIKit

class DetailViewController: UIViewController, Storybordable {
    
    weak var coordinator: AppCoordinator?
    var item: SheetItem?
    
    @IBOutlet private weak var uuidLabel: UILabel!
    @IBOutlet private weak var containLabel: UILabel!
      
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = item {
            setupVC(by: item)
        }
    }
    
    private func setupVC(by item: SheetItem) {
        self.title = String(item.content.split(separator: ".").first ?? "File")
        self.uuidLabel.text = "id: " + item.uuid
        self.containLabel.text = item.content
    }
 
}
