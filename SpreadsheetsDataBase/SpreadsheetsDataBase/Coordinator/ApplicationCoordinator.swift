//
//  ApplicationCoordinator.swift
//  SpreadsheetsDataBase
//
//  Created by Fedii Ihor on 19.06.2022

import UIKit

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        //self.navigationController.navigationBar.prefersLargeTitles = true
       // navigationController.navigationBar.layer.opacity = 0
    }
    
    func start() {
        let vc = MainViewController.createObject()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
  
    func goToDetail(_ item: SheetItem) {
        let vc = DetailViewController.createObject()
        vc.coordinator = self
        vc.item = item
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToMainVC(currentParentId: String,
                    title: String,
                    datasourse: Sheet ,
                    dataBase: Sheet) {
        let vc = MainViewController.createObject()
        vc.coordinator = self
        vc.currentParentID = currentParentId
        vc.title = String(title.split(separator: ".").first ?? "File")
        vc.dataSourse = datasourse.getSortedSheet()
        vc.dataBace = dataBase
        self.navigationController.pushViewController(vc, animated: true)
    }
    
}
