//
//  PushNotificationManager.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 3/22/26.
//

import UIKit

import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    func checkPermissionAndScheduleNotification() {
        
        let isEnabled = UserDefaults.standard.bool(forKey: "isDailyReminderEnabled")
        
        guard isEnabled else {
            print("앱 알림 권한이 거부되어 있습니다.")
            return
        }
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional, .ephemeral:
                    print("알림 권한이 확인되었습니다. 알림을 예약합니다.")
                    
                    self.scheduleDailyNotification(hour: 15, minute: 30)
                    
                case .denied:
                    print("시스템 알림 권한이 거부되어 있습니다.")
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    
                case .notDetermined:
                    print("아직 알림 권한을 요청하지 않았습니다.")
                    
                @unknown default:
                    break
                }
            }
        }
    }
    
    func scheduleDailyNotification(hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "디플레이"
        content.body = "오늘의 질문이 도착했어요"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "DailyReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("예약 실패: \(error.localizedDescription)")
            } else {
                print("\(hour)시 \(minute)분 예약 완료")
            }
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("모든 알림 예약이 취소되었습니다.")
    }
}
