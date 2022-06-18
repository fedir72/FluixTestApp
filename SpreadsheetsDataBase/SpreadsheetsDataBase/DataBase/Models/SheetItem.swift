//
//  SheetItem.swift
//  SpreadsheetsDataBase
//
//  Created by Fedii Ihor on 18.06.2022.
//

import Foundation

struct SheetItem: Codable {
    let uuid: String
    let parentId: String
    let type: TypeOfCell
    let content: String

    enum CodingKeys: String, CodingKey {
        case uuid = "A2AB993B-9D12-403F-A3B4-A77EEDE17521"
        case parentId = "55382859-D5F5-4A12-8AD6-308389929F56"
        case type = "f"
        case content = "вступление.docx"
    }
}

enum TypeOfCell: String, Codable {
    case d = "d"
    case f = "f"
}
