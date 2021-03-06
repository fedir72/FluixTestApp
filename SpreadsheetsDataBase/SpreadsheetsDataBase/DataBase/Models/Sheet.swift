//
//  Sheet.swift
//  SpreadsheetsDataBase
//
//  Created by Fedii Ihor on 18.06.2022.
//

import Foundation

typealias Sheet = [SheetItem]

extension Sheet {
    
    //MARK: - the functions for convinience access to sheet
    func getFilteredSheet(by id: String) -> Sheet {
        return self.filter { $0.parentId == id }
                   .sorted { $0.type == .d || $1.type != .d }
    }
    
    func getChildItems(by id: String) -> Sheet {
        return self.filter { $0.parentId == id }
    }
    
    func getSortedSheet() -> Sheet {
        return self.sorted { $0.type == .d || $1.type != .d }
    }
}
