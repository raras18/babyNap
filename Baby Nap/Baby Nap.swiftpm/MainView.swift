//
//  mainView.swift
//  Baby Nap
//
//  Created by Nibras Fitri Zuhra on 13/04/23.
//

import SwiftUI

struct mainView: View {

    @State private var currentDate = Date()
    @State private var isSleep: Bool = false
    @Binding var isActive: Bool
    @State private var dates: String = ""
    @State private var sleep: String = ""
    @State private var wake: String = ""
    @State private var inputDate: Date = Date()
    @State private var duration: String = ""
    
    @ObservedObject var dataViewModel = DataViewModel()
    
    let clockTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let calendar = Calendar.current
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    struct Timing: Identifiable, Codable {
        var id = UUID()
        var dates: String
        var sleep: String
        var wake: String
        var duration: String
        var durationInSecond: Int = 0
        var isSleep: Bool = false
    }
    
    class TimingManage {
        
        static let shared = TimingManage()
        private let userDefaults = UserDefaults.standard
        public let key = "timings"
        
        func updateTimings(_ timings: [Timing]){
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(timings) {
                userDefaults.set(encoded, forKey: key)
            }
        }
        
        func reset(){
            if var jsonDict = UserDefaults.standard.dictionary(forKey: key) {
                // Modify the value of the variable you want to reset to 0
                jsonDict[""] = 0
                
                // Save the modified dictionary back to UserDefaults
                UserDefaults.standard.set(jsonDict, forKey: key)
            }
        }
        
        func saveTiming(_ timing: Timing) {
            
            var timings = getTiming()
            timings.append(timing)
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(timings) {
                userDefaults.set(encoded, forKey: key)
            }
        }
        
        func getTiming() -> [Timing] {
            if let data = userDefaults.data(forKey: key) {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode([Timing].self, from: data) {
                    return decoded
                }
            }
            return []
        }
        
        func delete(){
            UserDefaults.standard.removeObject(forKey: "timings")
        }
    }
    
    var body: some View {
        
        if #available(iOS 16.0, *) {
            NavigationStack {
                VStack {
                    VStack {
                        VStack(alignment: .leading)
                        {
                            Spacer()
                            VStack{
                                Text("Sleep Information")
                            }
                            .font(.largeTitle)
                            .bold()
                            .toolbar{
                                Button{
                                    TimingManage.shared.delete()
                                    dataViewModel.removeChild(id: "")
                                }
                            label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .padding(15)
                            }
                            }
                            
                            Spacer()
                                .frame(height: 40)
                            VStack{
//                                DatePicker("", selection: $inputDate, displayedComponents: .date)
//                                    .frame(width: 0, alignment: .leading)
//                                    .background(.white)
                                    
                                Text("\(formatDate(currentDate))")
                                    .font(.title2)
                                    
                            }
                            ZStack{
                                Rectangle()
                                    .cornerRadius(30)
                                    .foregroundColor(customColor.blueSoftColor)
                                    .shadow(color:customColor.purpleColor, radius: 4, y: 4)
                                VStack{
                                    Text("Hi Moms!")
                                        .font(.title)
                                        .bold()
                                        .padding(.bottom, 10)
                                    if !dataViewModel.childData.isEmpty {
                                        Text("\(dataViewModel.childData[0].name) is now \(age().0) year and \(age().1) month. With that age, your baby's nap estimate is \(condition()) hours/day.")
                                        //
                                            .font(.title2)
                                            .multilineTextAlignment(.center)
                                    }
                                    
                                }.padding(15)
                            }
                            HStack{
                                ZStack{
                                    Rectangle()
                                        .cornerRadius(30)
                                        .foregroundColor(customColor.blueSoftColor)
                                        .shadow(color:customColor.purpleColor, radius: 4, y: 4)
                                    VStack{
                                        Text("Sleep Duration")
                                            .font(.title)
                                            .bold()
                                            .padding(20)
                                        Text("\(calculateAllSleepDuration().0)")
                                            .font(.title2)
                                        
                                    }
                                }
                                ZStack{
                                    Rectangle()
                                        .cornerRadius(30)
                                        .foregroundColor(customColor.blueSoftColor)
                                        .shadow(color:customColor.purpleColor, radius: 4, y: 4)
                                    VStack{
                                        Text("Time in Bed")
                                            .font(.title)
                                            .bold()
                                            .padding(20)
                                        Text("\(calculateAllSleepDuration().1) - \(calculateAllSleepDuration().2)")
                                            .font(.title2)
                                        
                                    }.onReceive(clockTimer){_ in currentDate = Date()}
                                }
                                Spacer()
                            }
                        }.padding(20)
                    }
                    
                    VStack{
                        HStack(alignment: .top){
                            VStack{
                                if (isSleep == false){
                                    Image("icon 2")
                                        .resizable()
                                        .frame(width: 250, height: 250)
                                }
                                else
                                {
                                    Image("icon 1")
                                        .resizable()
                                        .frame(width: 200, height: 250)
                                }
                            }
                            VStack{
                                ZStack{
                                    if (isSleep == false){
                                        Rectangle()
                                            .cornerRadius(30)
                                            .foregroundColor(.white)
                                        Text("\(resultCapt())")
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.black)
                                            .font(.title2)
                                            .padding(15)
                                    }
                                    else
                                    {
                                        Rectangle()
                                            .cornerRadius(30)
                                            .foregroundColor(.white)
                                            .frame(width: 300)
                                        Text("""
                    Ssstt.....
                    Your Baby is Sleeping
                    """)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                        .font(.title2)
                                        //.padding(15)
                                    }
                                    
                                }.frame(height: 150)
                            }
                        }
                        .padding(20)
                        
                    }
                    VStack{
                        Button{
                            if isSleep == false {
                                resetDuration()
                                sleep = (formatTime(currentDate))
                                isSleep = true
                                let timing = Timing(dates: formatDate(currentDate), sleep: sleep, wake: "", duration: "", isSleep: isSleep)
                                TimingManage.shared.saveTiming(timing)
                            }
                            else {
                                wake = (formatTime(currentDate))
                                duration = (calculateSeconds().1)
                                isSleep = false
                                updateData()
                                
                            }
                        }
                    label:{
                        if isSleep == false{
                            Text("Sleep")
                                .foregroundColor(.black)
                                .font(.title)
                                .bold()
                                .frame(width: 700, height: 80)
                                .background(customColor.blueSoftColor)
                                .cornerRadius(20)
                                .shadow(color:.white, radius: 2, y: 2)
                        }
                        else{
                            Text("Wake Up")
                                .foregroundColor(.red)
                                .font(.title)
                                .bold()
                                .frame(width: 700, height: 80)
                                .background(customColor.blueSoftColor)
                                .cornerRadius(20)
                                .shadow(color:.white, radius: 2, y: 2)
                        }
                            
                    }
                    
                    }
                    
                }
                .background(LinearGradient(gradient: Gradient(colors: [Color("purple"), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                
            }.navigationBarBackButtonHidden(true)
                
                
                
        } else {
            // Fallback on earlier versions
        }
    }
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
    
    func calculateSeconds() -> (Int, String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        var sleep_2 = ""
        let allTimings = TimingManage.shared.getTiming()
        
        for timing in allTimings {
            sleep_2 = timing.sleep
        }
        
        let diff = formatter.date(from: wake)
        let diff2 = formatter.date(from: sleep_2)
        let diffTime = Int((diff?.timeIntervalSince1970 ?? 0) - (diff2?.timeIntervalSince1970 ?? 0))
        let minutes = (diffTime % 3600) / 60
        let hours = diffTime / 3600
        let seconds = (diffTime%3600)%60
        let durationSecond = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        
        return (diffTime, durationSecond)
    }
    
    func calculateAllSleepDuration() -> (String, String, String, Int) {
        var totalSeconds = 0
        var wake_2 = ""
        var sleep_2 = ""
        
        // loop all the sleep records
        let allTimings = TimingManage.shared.getTiming()
        
        
        for timing in allTimings {
            totalSeconds += timing.durationInSecond
            wake_2 = timing.wake
            sleep_2 = timing.sleep
        }
        
        // if totalSeconds == 0 { return ("" , "" , "") }
        
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let second = (totalSeconds % 3600) % 60
        let totalDuration = String(format: "%02d:%02d:%02d", hours, minutes, second)
        
        return (totalDuration, sleep_2, wake_2, totalSeconds)
    }
    
    func updateData () {
        var timings: [Timing] = TimingManage.shared.getTiming()
        var selectedIndex: Int = 0
        if(timings.count > 0){
            selectedIndex = timings.count-1
            let timing = Timing(dates: timings[selectedIndex].dates, sleep: timings[selectedIndex].sleep, wake: wake, duration: duration, durationInSecond: calculateSeconds().0, isSleep: false)
            
            timings[selectedIndex] = timing
            
            TimingManage.shared.updateTimings(timings)
        }
    }
    
    func resultCapt () -> String{
        var hasil = ""
        
        let timings: [Timing] = TimingManage.shared.getTiming()
        var selectedIndex: Int = 0
        
        if(timings.count > 0){
            selectedIndex = timings.count-1
            
            if timings[selectedIndex].dates == formatDate(inputDate) {
                if (calculateAllSleepDuration().3) > (condition()*3600) {
                    hasil = """
Hi Moms! I think you have to stay up late tonight 🥱
Fighting!🫶
"""
                }
                else
                {
                    hasil = """
Hi Moms! I think you can sleep with your baby tonight😄
Have a good rest✨
"""
                }
            }
        }
        else
        {
            
            
        }
        return hasil
    }
    
    func resetDuration () {
        let timings: [Timing] = TimingManage.shared.getTiming()
        var selectedIndex: Int = 0
        
        if(timings.count > 0){
            selectedIndex = timings.count-1
            
            if timings[selectedIndex].dates != formatDate(currentDate) {
                TimingManage.shared.reset()
            }
        }
    }
    
    func age() -> (Int, Int){
        let days = dataViewModel.childData[0].age
        let years = days / 365 // calculate the number of years
        let remainingDays = days % 365 // calculate the remaining days
        let months = remainingDays / 30 // calculate the months
        
        return (years, months)
    }
    
    func condition() -> (Int){
        let years = age().0
        let months = age().1
        if years > 0 {
            let nap = 3
            return nap
        }
        else if years == 0 && months >= 1 && months < 3 {
            let nap = 7
            return nap
        }
        else if years == 0 && months >= 3 && months < 6 {
            let nap = 5
            return nap
        }
        else if years == 0 && months >= 6 && months < 12 {
            let nap = 3
            return nap
        }
        else if years == 0 && months == 0
        {
            let nap = 8
            return nap
            
        }
        return 0
    }
    
}


struct mainView_Previews: PreviewProvider {
    static var previews: some View {
        mainView(isActive: .constant(false))
    }
}
