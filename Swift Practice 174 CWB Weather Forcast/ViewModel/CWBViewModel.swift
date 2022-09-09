//
//  CWBViewModel.swift
//  Swift Practice 174 CWB Weather Forcast
//
//  Created by Dogpa's MBAir M1 on 2022/9/9.
//

import Foundation

final class CWBViewModel: ObservableObject {
    
    @Published var weekForcastArray = [ForcastModel]()
    
    //接收JSON解析的台灣行政區Array
    @Published var taiwanCityAndDistArray: [TaiwanDist] = []
    
    //從taiwanCityAndDistArray過濾出台灣城市名稱加入到cityArray
    @Published var cityArray: [String] = []
    
    //接收依照使用者選擇的城市，指定城市內的行政區名稱
    @Published var districtArray: [String] = []
    
    @Published var cityDistDict:[String:[String]] = [:]
    
    //與城市名稱picker binding的值
    //若是發生改變，代表使用者選了指定的城市
    //將districtSelectIndex設定為0以防止使用者的下一個行政區數量小於目前的值造成閃退
    //執行fetchDistrict將districtArray更換為新選擇的城市的行政區
    @Published var citySelectIndex = 0 {
        didSet {
            districtSelectIndex = 0
            districtArray = fetchDistrict(selectIndex: self.citySelectIndex)
        }
    }
    
    //與行政區名稱picker binding的值
    @Published var districtSelectIndex = 0
    
    //解析JSON
    //透過迴圈將所有縣市名稱加入到cityArray
    //並在透過巢狀迴圈加入先將對應回圈內的縣市名稱中的行政區加入到filterDistrictArray
    //接著將其轉換成字典的類別
    //並透過自定義的fetchDistrict將districtArray的值取得對應該字典內縣市的名稱
    func decodeJSON() {
        
        taiwanCityAndDistArray = load("taiwanCountyAndDist.json")
        
        cityArray = []
        
        for i in 0..<taiwanCityAndDistArray.count {
            
            cityArray.append(taiwanCityAndDistArray[i].name)
            var filterDistrictArray = [String]()
            for x in 0 ..< taiwanCityAndDistArray[i].districts.count {
                filterDistrictArray.append(taiwanCityAndDistArray[i].districts[x].name)
            }
            cityDistDict["\(taiwanCityAndDistArray[i].name)"] = filterDistrictArray
            
        }
        districtArray = fetchDistrict(selectIndex: 0)
    }
    
    /// 透過指定參數回傳指定taiwanCityAndDistArray縣市內的行政區字典的value
    ///  - Parameters:
    ///   - selectIndex: 對應taiwanCityAndDistArray內指定的位置的縣市名稱
    ///
    ///  - Returns:  相對應的字典value
    func fetchDistrict (selectIndex: Int) -> [String] {
        return cityDistDict["\(taiwanCityAndDistArray[selectIndex].name)"] ?? [""]
    }
    

    func fetchSelectedDistForcast () {
        print("\(#function) 開駛向中央氣象局取得資料")
        let countyIndex = countyCWBIndexDict[cityArray[citySelectIndex]] ?? ""
        let distStr = districtArray[districtSelectIndex]
        print("選擇API: \(countyIndex), 鄉鎮市區：\(distStr)")
        
        guard let fetchStr = "https://opendata.cwb.gov.tw/api/v1/rest/datastore/\(countyIndex)?Authorization=你的中央氣象局開放平台授權碼&format=JSON&locationName=\(distStr)&elementName=T,WeatherDescription".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("未成功建立網址..")
            return
        }
        
        
        print(fetchStr)
        guard let url = URL(string: fetchStr) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            
            guard let data = data, error == nil else {return}
            
            do{
                let decoder = JSONDecoder()
                decoder.dataDecodingStrategy = .base64
                let searchResponse = try decoder.decode(CWBForcast.self, from: data)
//                print(searchResponse.records.locations[0].location[0].weatherElement[0].time)
//                print(">>><<<<")
//                print(searchResponse.records.locations[0].location[0].weatherElement[1].time)
                
                DispatchQueue.main.async {
                    self!.weekForcastArray = []
                    for i in 0..<searchResponse.records.locations[0].location[0].weatherElement[1].time.count {
                        //直接加入JSON檔案第一個資料
                        if i == 0 {
                            //使用者可能晚上取得JSON，這時第一天只會剩晚上的預報，
                            //所以這裡的天氣圖示需判斷是要放入白天還是晚上的圖，
                            //後面的天氣預報則統一使用白天的預報資料。
                            self!.weekForcastArray.append(ForcastModel(startTime: searchResponse.records.locations[0].location[0].weatherElement[0].time[i].startTime,
                                                                       week: searchResponse.records.locations[0].location[0].weatherElement[1].time[0].startTime.getWeekDay(),
                                                                       temperature: searchResponse.records.locations[0].location[0].weatherElement[0].time[0].elementValue[0].value,
                                                                       forcastImage:
                                                                        searchResponse.records.locations[0].location[0].weatherElement[0].time[i].endTime .contains("06") ?  allWeatherConditionDict[searchResponse.records.locations[0].location[0].weatherElement[1].time[0].elementValue[0].value.getForcastDescription()]?.night ?? "晴天-D" : allWeatherConditionDict[searchResponse.records.locations[0].location[0].weatherElement[1].time[0].elementValue[0].value.getForcastDescription()]?.day ?? "晴天-D"
                                                                      ))
                        }else{
                            //因為中央氣象局同一天會有白天的預報與晚上的預報，我們只拿白天的預報，
                            //透過日期比對同一天沒有加入的話表示可以加入白天的預報，
                            //若weekForcastArray內有值表示已經有白天預報，晚上預報不再加入。
                            if searchResponse.records.locations[0].location[0].weatherElement[0].time[i].startTime.getStrDate() !=  self!.weekForcastArray[self!.weekForcastArray.count-1].startTime.getStrDate(){
                                self!.weekForcastArray.append(ForcastModel(startTime: searchResponse.records.locations[0].location[0].weatherElement[0].time[i].startTime,
                                                                           week: searchResponse.records.locations[0].location[0].weatherElement[0].time[i].startTime.getWeekDay(),
                                                                           temperature: searchResponse.records.locations[0].location[0].weatherElement[0].time[i].elementValue[0].value,
                                                                           forcastImage: allWeatherConditionDict[searchResponse.records.locations[0].location[0].weatherElement[1].time[i].elementValue[0].value.getForcastDescription()]?.day ?? "晴天-D"))
                            }
                        }
                    }
                    print( self!.weekForcastArray)
                }
            }catch{
                print("解析失敗....\(error)")
            }
        }
        //執行task
        task.resume()
    }
    
}
