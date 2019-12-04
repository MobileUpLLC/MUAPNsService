//
//  APNsSerive.swift
//
//  Created by Ed on 25/10/2019.
//  Copyright © 2019 MobileUp. All rights reserved.
//

import UIKit

import UserNotifications

public class MUAPNsService : NSObject  {
    
    // MARK: - Public property
    
    public var token : Data?
    
    private(set) public var uid : String?
    
    public weak var delegate : MUPushService?
    
//    private(set) public var pushRegisterResponse : PushRegisterResponse?
    
    private(set) public var pushUid : String?
    
    // MARK: - Public Methods
                   
    /**
        Регистрация APNS на сервере (/apns/register)
     */
    public func register(completion: @escaping (Error?) -> Void) {
        
        DispatchQueue.global().async { [weak self] in
            
            while self?.token == nil {
                
                Thread.sleep(forTimeInterval: 1)
            }

            PushServer.shared.request(
                                    
                url        : "apns/register",
                method     : .post,
                headers    : ["Content-Type" : "application/json"],
                body       : PushServiceRegisterInfo().dictionary,
                encoding   : .json) { [weak self] (answer:Any?, error:Error?) in
                    
                    self?.pushUid = answer as? String
                        
                    completion(error)
            }
            
        }
    }
    
    /**
        Регистрация нотификаций на устройстве
     
        Выполняется в AppDelegate
     */
    public func registerForRemoteNotifications(application:UIApplication) {
        
        if #available(iOS 10.0, *) {

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            
          UNUserNotificationCenter.current().requestAuthorization(
            
            options: authOptions,
            
            completionHandler: {_, _ in })
            
        } else {
            
          let settings: UIUserNotificationSettings =
            
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        UNUserNotificationCenter.current().delegate = self
        
    }
    
}

extension MUAPNsService: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    public func userNotificationCenter(

        _ center                                : UNUserNotificationCenter,
        didReceive response                     : UNNotificationResponse,
        withCompletionHandler completionHandler : @escaping () -> Void) {

        let userInfo = response.notification.request.content.userInfo

        print(userInfo)

        completionHandler()
        
        delegate?.action(from: userInfo)

        delegate?.postAPNsNotification()

    }

    public func userNotificationCenter(

        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        print(notification.request.content.userInfo)

//        completionHandler([.sound, .alert])
    }
    
}

public extension Notification.Name {
    
    static let didReceivedFromAPNs = Notification.Name("didReceivedFromAPNs")
}
