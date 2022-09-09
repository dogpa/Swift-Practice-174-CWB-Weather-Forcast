//
//  CountyAndDIstModel.swift
//  Swift Practice 174 CWB Weather Forcast
//
//  Created by Dogpa's MBAir M1 on 2022/9/9.
//

import Foundation

//台灣行政區JSON第一層
struct TaiwanDist: Decodable {
    let name: String                //縣市名稱
    let districts: [DistrictInfo]   //縣市內的鄉鎮行政區型別為DistrictInfo
}

//台灣行政區JSON第二層
struct DistrictInfo: Decodable {
    let zip: String                 //鄉鎮行政區的郵遞區號
    let name: String                //鄉鎮行政區的名字
}

///解析JSON
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
