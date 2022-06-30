//
//  Database.swift
//  SpreadsheetsDataBase
//
//  Created by Fedii Ihor on 18.06.2022.
//

import Foundation

fileprivate enum HTTPmethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
}


class DataBase {
    //zcofu8bnd3ldl Sheet1
    //GET https://sheetdb.io/api/v1/zcofu8bnd3ldl

    //i8s3hscsk4ajd  DataSourse
    //https://sheetdb.io/api/v1/i8s3hscsk4ajd
    
    //POST https://sheetdb.io/api/v1/i8s3hscsk4ajd
    //PATCH/PUT https://sheetdb.io/api/v1/58f61be4dda40/{column}/{value}
    //DELETE https://sheetdb.io/api/v1/i8s3hscsk4ajd/D439E776-2325-401A-AEE6-2076868631AE/00FD826C-D33D-4B76-8388-B417843D472A
    
    var id: String
    let session = URLSession(configuration: .default)
    
    init(api id: String) {
        self.id = id
    }
    
    lazy var mainUrlString: String = {
        return "https://sheetdb.io/api/v1/" + id
    }()
    
   open func obtainSheet(completion: @escaping (Result<Sheet,SheetError>) -> Void) {
        guard let url = URL(string: mainUrlString) else {
            completion(.failure(.apiError))
            return }
       session.dataTask(with: url) { data, _ , error in
            guard error == nil else {
                completion(.failure(.invalidEndpoint))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
           guard let sheet = self.decodejson(type: Sheet.self, from: data) else {
               completion(.failure(.serializationError))
               return
           }
           completion(.success(sheet))
        }
       .resume()
        
    }
    
    open func postSheetItem(item: SheetItem,
                          completion: @escaping(Result<Int,SheetError>) -> Void ) {
        guard let url = URL(string: mainUrlString) else {
            completion(.failure(.invalidEndpoint))
        return
        }
        let putdata = PutData(data: [item])
        guard let newItem = try? JSONEncoder().encode(putdata) else {
            print("1")
            completion(.failure(.serializationError))
            return
        }
       // print("newItem",newItem)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPmethod.post.rawValue
        request.httpBody = newItem
        request.setValue("\(newItem.count)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.noData))
                return
            } else if let response = response as? HTTPURLResponse,
                      response.statusCode == 201 {
                guard let obj = self.decodejson(type: PutResponse.self, from: data) else {
                    completion(.failure(.serializationError))
                    return
                }
                print("obj",obj)
                completion(.success(obj.created))
            }
        }.resume()
    }
    
    func deleteCell(by uuid: String,completion: @escaping (Result<DeleteJSON,SheetError>) -> Void) {
      let urlStr = mainUrlString + "/D439E776-2325-401A-AEE6-2076868631AE/\(uuid)"
        if let url = URL(string: urlStr) {
         var request = URLRequest(url: url)
            request.httpMethod = HTTPmethod.delete.rawValue
            session.dataTask(with: request) { data, resp, error in
                guard error == nil else {
                    completion(.failure(.noData))
                    return
                }
                if let resp = (resp as? HTTPURLResponse){
                    print("status",resp.statusCode)
                }
                guard let json = self.decodejson(type: DeleteJSON.self, from: data) else {
                    completion(.failure(.serializationError))
                    return
                }
                completion(.success(json))
            }
        } else {
            completion(.failure(.invalidEndpoint))
        }
    }
}

private extension DataBase {
 
    func decodejson<T:Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let error {
            print("data has been not decoded : \(error.localizedDescription)")
            return nil
        }
    }
  
    func executeInMainThread<D:Decodable>(with result: Result<D,SheetError>,completion: @escaping ((Result<D,SheetError>) -> Void) ) {
        DispatchQueue.main.async { completion(result)}
    }
    
}
