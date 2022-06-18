//
//  ViewController.swift
//  SpreadsheetsDataBase
//
//  Created by Fedii Ihor on 18.06.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    let network = DataBase(api: "zcofu8bnd3ldl")
    var dataSourse: Sheet = [] {
        didSet {  print(dataSourse) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        network.obtainSheet { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sheet):
                    self.dataSourse = sheet.getMainLayerOfSheet()
                case .failure(let error):
                    self.someWrongAlert(self, "Atension", error.localizedDescription)
                }
            }
        }
    }
    
   

}

