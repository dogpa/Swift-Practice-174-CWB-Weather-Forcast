//
//  TypeExtension.swift
//  Swift Practice 174 CWB Weather Forcast
//
//  Created by Dogpa's MBAir M1 on 2022/9/9.
//

import Foundation

extension String {
    
    
    /// 透過傳入的中央氣象局的時間格式回傳時間，用來比較資料。
    /// - Returns: 中央氣象局時間字串的時間
    func getStrDate() -> Date {
        let dateStr = String(self.prefix(upTo: self.index(self.startIndex, offsetBy: 10)))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
        let returnDate = dateFormatter.date(from: dateStr)
        
        if returnDate != nil {
            return returnDate!
        }else{
            return dateFormatter.date(from: dateFormatter.string(from: Date()))!
        }
    }
    
    
    /// 透過中央氣象局的時間格式取得日期換算的對應星期幾
    /// - Returns: 回傳星期幾
    func getWeekDay () -> String {
        let weekDateFormatter = DateFormatter()
        weekDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        weekDateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        weekDateFormatter.locale = Locale(identifier: "zh_Hant_TW")
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: weekDateFormatter.date(from: self)!)
        let weekday = dateComponents.weekday!
        switch weekday {
        case 1 :
            return "日"
        case 2 :
            return "一"
        case 3 :
            return "二"
        case 4 :
            return "三"
        case 5 :
            return "四"
        case 6 :
            return "五"
        case 7 :
            return "六"
        default:
            return "日"
        }
    }
    
    
    /// 透過中央氣象局的天氣綜合預報字串，透過切割字串取得天氣預報的字串，用於顯示圖示。依照天氣預報後會有句號字符，透過字串Map後去判斷句號之前的字數總數後再切割字串取得天氣預報描述。
    /// - Returns: 當天的天氣預報的天氣概況
    func getForcastDescription () -> String {
        let strArray = self.map { String($0) }
        print(strArray.count)
        var forcastStr = ""
        var desIndex = 0
        while !forcastStr.contains("。")  {
            print(forcastStr,"forcastStr")
                forcastStr += strArray[desIndex]
                desIndex += 1
                print(forcastStr, desIndex)
            }
        let descriptionStr = String(self.prefix(upTo: self.index(self.startIndex, offsetBy: desIndex-1)))
        print("\(descriptionStr) 氣象預報圖示")
        return descriptionStr
    }
}
