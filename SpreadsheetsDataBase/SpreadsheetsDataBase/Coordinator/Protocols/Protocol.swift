//
//  Protocol.swift
//  SpreadsheetsDataBase
//
//  Created by Fedii Ihor on 19.06.2022.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
    func goToDetail(_ item: SheetItem)
    func goToMainVC(title: String,
                    datasourse: Sheet ,
                    dataBase: Sheet)
}
