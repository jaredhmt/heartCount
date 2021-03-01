//
//  ContentView.swift
//  heartCount
//
//  Created by Jared Hale on 2/28/21.
//

import SwiftUI
import HealthKit

//func fetchHealthData() -> Void {
//    healthStore = HKHealthStore()
//    requestAccess()
//}

func requestAccess() -> Void {
    let healthType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
    
    healthStore?.requestAuthorization(toShare: nil, read: [healthType]) { success, error in
        if success {
            
        } else {
            
        }
    }
}
func fetchHealthData() -> (bpms: [Double], times: [Date]) {
    
    var bpms: [Double] = []
    var times: [Date] = []
    
    
    let healthStore = HKHealthStore()
    if HKHealthStore.isHealthDataAvailable() {
        let readData = Set([
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ])
        
        healthStore.requestAuthorization(toShare: [], read: readData) { (success, error) in
            if success {
                let calendar = NSCalendar.current
                
                var anchorComponents = calendar.dateComponents([.day, .month, .year, .weekday], from: NSDate() as Date)
                
                let offset = 0 //(7 + anchorComponents.weekday! - 2) % 7
                
                anchorComponents.day! -= offset
                anchorComponents.hour = 0
                
//                guard let anchorDate = Calendar.current.date(from: anchorComponents) else {
//                    fatalError("*** unable to create a valid date from the given components ***")
//                }
                
                let interval = NSDateComponents()
                interval.minute = 1
                                    
                let endDate = Date()
                                            
//                guard let startDate = calendar.date(byAdding: .month, value: -1, to: endDate) else {
//                    fatalError("*** Unable to calculate the start date ***")
//                }
                let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
                                    
                guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
                    fatalError("*** Unable to create a step count type ***")
                }
 
                let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                        quantitySamplePredicate: nil,
                                                            options: .discreteAverage,
                                                            anchorDate: startDate,
                                                            intervalComponents: interval as DateComponents)
                
                query.initialResultsHandler = {
                    query, results, error in
                    
                    guard let statsCollection = results else {
                        fatalError("*** An error occurred while calculating the statistics: \(String(describing: error?.localizedDescription)) ***")
                        
                    }
                                        
                    statsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                        if let quantity = statistics.averageQuantity() {
                            let date = statistics.startDate
                            //for: E.g. for steps it's HKUnit.count()
                            let value = quantity.doubleValue(for: HKUnit(from: "count/min"))
//                            print("done")
                            print(value)
//                            print(date)
                            bpms.append(value)
                            times.append(date)
                            
                                                        
                        }
                    }
                    
                }
                
                healthStore.execute(query)
//                return(bpms, times)
                
                
            } else {
                print("Authorization failed")
            }
        }
    }
    return(bpms, times)
}

func calculatebpms(_ bpms:[Double], _ times:[Date]) -> Void {
    print("HELLO I AM CALCULATING")
    var absTime: [Double] = []
    let calendar = Calendar.current
    for time in times{
//        print(time)
        var hour = calendar.component(.hour, from: time)
        var min = calendar.component(.minute, from: time)
        var sec = calendar.component(.second, from: time)
        var thisAbsTime = Double(hour) * 60.0 + Double(min) + Double(sec) / 60.0
//        print(thisAbsTime)
        absTime.append(thisAbsTime)
    }
        
    print("I AM CALCULATED")
}

var healthStore : HKHealthStore?

struct ContentView: View {
    var body: some View {
        if HKHealthStore.isHealthDataAvailable() {
            mainView().onAppear(){
                var myData = fetchHealthData()
                print(myData.bpms)
                calculatebpms(myData.bpms,myData.times)
            }
            
        } else{
            Text("Health Data Not Available")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
