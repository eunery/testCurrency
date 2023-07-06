//
//  currencyTestApp.swift
//  currencyTest
//
//  Created by Sergei Kulagin on 01.07.2023.
//

import SwiftUI
import BackgroundTasks

@main
struct currencyTestApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var phase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .background:
                self.scheduleAppRefresh()
            case .active:
                print("app is active")
                BGTaskScheduler.shared.getPendingTaskRequests(completionHandler: { request in
                    print("task requests: \(request)")
                })
            case .inactive:
                print("app is inactive")
            default: break
            }
            
        }
        .backgroundTask(.appRefresh("com.check.currency")) {
            await notify()
            // запуск таска в консоли дебаггера
            // e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.check.currency"]
        }
    }
    func scheduleAppRefresh() {
        let request = BGProcessingTaskRequest(identifier: "com.check.currency")
        request.earliestBeginDate = Calendar.current.date(bySettingHour: 12, minute: 00, second: 00, of: .now)
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("ERROR: -----> \(error)")
        }
        print("task scheduled")
        // breakpoint
    }
    
    func notify() async {
        let content = UNMutableNotificationContent()
        content.title = "Поступил новый курс"
        content.subtitle = "Скорее смотри"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        if await isNewValue() {
            try? await UNUserNotificationCenter.current().add(req)
        }
    }

    func isNewValue() async -> Bool{
        var flag = false
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.string(from: Date.now)
        var url = URLComponents(string: "https://www.cbr.ru/scripts/XML_daily.asp")
        let queryItems = [URLQueryItem(name: "date_req", value: date)]
        url?.queryItems = queryItems
        let request = URLRequest(url: (url?.url)!)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print(data.count)
            let parser = CurrentXMLParser(data: data)
            if parser.parse() {
                if (parser.currency.value != KeychainManager.get(str: "currentCurrency")) {
                    KeychainManager.saveLastCurrency(number: KeychainManager.get(str: "currentCurrency"))
                    KeychainManager.saveCurrent(number: parser.currency.value)
                    flag = true
                }
            }
        } catch {
            return flag
        }
        return flag
    }
}
