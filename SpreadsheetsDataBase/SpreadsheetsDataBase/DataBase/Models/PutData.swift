//
//  PutData.swift
//  SpreadsheetsDataBase
//
//  Created by Fedii Ihor on 21.06.2022.
//

import Foundation
//a sample of data send to spreadsheet
struct PutData: Codable {
    let data: Sheet
}
// a sample data is response from spreadsheet
struct PutResponse: Codable {
    let created: Int //response is number of created items
}
