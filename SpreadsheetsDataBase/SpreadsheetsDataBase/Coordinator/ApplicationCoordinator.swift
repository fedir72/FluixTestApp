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
        vc.title = item.content
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToMainVC(_ datasourse: Sheet , _ dataBase: Sheet) {
        let vc = MainViewController.createObject()
        vc.coordinator = self
        vc.dataSourse = datasourse
        vc.dataBace = dataBase
        self.navigationController.pushViewController(vc, animated: true)
    }
    
}
