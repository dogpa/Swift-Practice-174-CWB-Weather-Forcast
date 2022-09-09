//
//  ForcastModel.swift
//  Swift Practice 174 CWB Weather Forcast
//
//  Created by Dogpa's MBAir M1 on 2022/9/9.
//

import Foundation


/// 顯示在View上的ForcastModel，startTime是用來比較並過濾同一天的晚上資料(預報除了第一天可能在晚上使用，其餘皆顯示白天的預報資料)
struct ForcastModel {
    let startTime:      String  //儲存原始的JSON的Start，用來比對用。
    let week:           String  //星期幾
    let temperature:    String  //溫度
    let forcastImage:   String  //對應顯示照片
}


