//
//  loadData.swift
//  heartCount
//
//  Created by Jared Hale on 2/28/21.
//

//import Foundation
//import SwiftUI
//import HealthKit
//
//func loadData() -> Void {
//    let healthType = HKSampleType.quantityType(forIdentifier: .heartRate)!
//    let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
//    let myPred = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictStartDate)
//    let sort = [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
//
//    let newQ = HKSampleQuery(
//        sampleType: healthType,
//        predicate: myPred,
//        limit: 1440,
//        sortDescriptors: sort,
//        resultsHandler: <#T##(HKSampleQuery, [HKSample]?, Error?) -> Void#>)
//
//    healthStore?.execute(newQ)
//}
