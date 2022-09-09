//
//  ContentView.swift
//  Swift Practice 174 CWB Weather Forcast
//
//  Created by Dogpa's MBAir M1 on 2022/9/9.
//

import SwiftUI

struct ContentView: View {
    //裝置螢幕寬
    let screenWidth = UIScreen.main.bounds.width
    
    //裝置螢幕高
    let screenHeight = UIScreen.main.bounds.height
    
    @StateObject var CWBVm = CWBViewModel()
    
    var body: some View {
        VStack{
            VStack {
                Text("選擇營區縣市：")
                
                HStack{
                    Spacer()
                    Text("行政區：")
                    
                    Spacer()
                    Picker(selection: $CWBVm.citySelectIndex,label: Text("")) {
                        ForEach(0..<$CWBVm.cityArray.count, id: \.self) { name in
                            Text("\(CWBVm.cityArray[name])")
                            
                        }
                    }
                    //.frame(width: viewWidth/2, height: viewHeight/3)
                    .pickerStyle(.menu)
                    .clipped()
                    Spacer()
                    Picker(selection: $CWBVm.districtSelectIndex, label: Text("")) {
                        ForEach(0..<$CWBVm.districtArray.count, id: \.self) { name in
                            Text("\(CWBVm.districtArray[name])")
                                .tag(name)
                                .font(.system(size: 35))
                        }
                        
                    }
                    .pickerStyle(.menu)
                    .clipped()
                    Spacer()
                }
                .frame(width: screenWidth, alignment: .center)
            }
            
            
            Button {
                CWBVm.fetchSelectedDistForcast()
            } label: {
                Text("取得天氣預報")
            }
            
            
            Spacer()
            //確定資料已經完全取得後再顯示
            if CWBVm.weekForcastArray.count > 6 {
                VStack {
                    HStack {
                        ForcastView(arrayIndex: 0, forcastArray: CWBVm.weekForcastArray)
                        ForcastView(arrayIndex: 1, forcastArray: CWBVm.weekForcastArray)
                        ForcastView(arrayIndex: 2, forcastArray: CWBVm.weekForcastArray)
                        ForcastView(arrayIndex: 3, forcastArray: CWBVm.weekForcastArray)
                        ForcastView(arrayIndex: 4, forcastArray: CWBVm.weekForcastArray)
                        ForcastView(arrayIndex: 5, forcastArray: CWBVm.weekForcastArray)
                        ForcastView(arrayIndex: 6, forcastArray: CWBVm.weekForcastArray)
                    }
                }
            }
            Spacer()
            
        }
        .onAppear {
            CWBVm.decodeJSON()
        }
    }
}


///顯示氣象預報的View
struct ForcastView: View {
    //裝置螢幕寬
    let screenWidth = UIScreen.main.bounds.width
    
    //裝置螢幕高
    let screenHeight = UIScreen.main.bounds.height
    
    var arrayIndex : Int
    var forcastArray: [ForcastModel]
    var body: some View {
        VStack {
            Text(forcastArray[arrayIndex].week)
            Text(forcastArray[arrayIndex].temperature+"°")
            Image(forcastArray[arrayIndex].forcastImage)
                .resizable().scaledToFit()
                .frame(width: screenWidth/9, height: screenWidth/9, alignment: .center)
        }
    }
}
//驗證圖示的是否都有顯示
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            ScrollView {
//                ForEach(allWeatherConditionArray, id:\.self) { condition in
//                    VStack{
//                        Text(condition.weatherDescription)
//                        HStack {
//                            Image(condition.day)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 50, height: 50, alignment: .center)
//
//                            Image(condition.night)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 50, height: 50, alignment: .center)
//                        }
//                        Divider()
//                    }
//
//                }
//            }
//        }
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
