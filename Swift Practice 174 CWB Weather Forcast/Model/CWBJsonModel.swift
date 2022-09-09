//
//  CWBJsonModel.swift
//  Swift Practice 174 CWB Weather Forcast
//
//  Created by Dogpa's MBAir M1 on 2022/9/9.
//

import Foundation

//解析中央氣象局預報JSON
struct CWBForcast: Codable {
    var records: CWBRecords
}

struct CWBRecords: Codable {
    var locations : [CountyInfo]
}

struct CountyInfo: Codable {
    var location : [DistInfo]
    var locationsName: String
    var dataid: String
}

struct DistInfo: Codable {
    var geocode: String
    var lat: String
    var locationName: String
    var lon: String
    var weatherElement : [DistForcast]
}

struct DistForcast: Codable {
    var description: String
    var elementName: String
    var time = [ForcastTime]()
}

struct ForcastTime: Codable {
    var elementValue = [ForcastTDValue]()
    var endTime: String
    var startTime: String
}

struct ForcastTDValue: Codable {
    var value: String
}



