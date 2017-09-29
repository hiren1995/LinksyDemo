//
//  AppDelegate.swift
//  LinksyDemo
//
//  Created by APPLE MAC MINI on 12/07/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MBProgressHUD


var device_token:String? = nil



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
       func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //---------------Push notification settings start---------------
        
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        
        let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        
        //UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        
        application.registerUserNotificationSettings(pushNotificationSettings)
        
        application.registerForRemoteNotifications()
        
        
        //---------------Push notification settings stop----------------
        
                
        let temp = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
        
        if(temp == nil)
        {
            //--------------------------- check the user if user is already logged in ---------------------
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController: dummyViewController = mainStoryboard.instantiateViewController(withIdentifier: "dummyViewController") as! dummyViewController
            
            self.window?.rootViewController = nextViewController
            
            //self.window?.rootViewController?.present(UIViewController.self, animated: true, completion: nil)
            
            self.window?.makeKeyAndVisible()
            
            //--------------------------- check the user if user is already logged in End---------------------
            
        }
        else
        {
            
            //--------------------------- Check the user is in database or not or if manually deleted -----------------------
            
            let ifuser1 = JSON(temp!)
        
            //print(ifuser["linkedin_login"])
            
            let baseUrl = "https://bulale.in/linksy/api/index.php/"
            
            //let x = JSON(linkedinparameters.object(forKey: "linkedinparameters")!)
            
            //print(x)
        
            //let AuthAcess = x["linkedin_id"]
            
            //let Authid = x["oauth2_access_token"]
            
            //let parametersdata = ["login_type":"linkedin","oauth2_access_token": AuthAcess , "linkedin_id": Authid]
            
            let parametersdata = ["user_id": ifuser1["linkedin_login"][0]["user_id"]]
           
            //print(parametersdata)
            
            Alamofire.request(baseUrl+"user/get_user_details", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (apiresponseuserdata) in
                
                if((apiresponseuserdata.response) != nil)
                {
                    //print(apiresponseuserdata.result.value!)
                    //print(apiresponseuserdata.response!)
                    let x = JSON(apiresponseuserdata.result.value!)
                    
                    //print(x)
                    
                    if(x["status"] == "success")
                    {
                        //userpersonalinfo.set(apiresponseuserdata.result.value, forKey: "userpersonalinfo")
                        //let m = userpersonalinfo.object(forKey: "userpersonalinfo")
                        //print(m!)
                        
                        
                        //------------------------------------ Code for setting the swipe cards data into the defaults-----------------
                        
                        if let userinfo = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
                        {
                            let baseUrl = "https://bulale.in/linksy/api/index.php/"
                            
                            let tempdata = JSON(userinfo)
                            
                            let parametersdata:[String : String] = ["user_id": tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string! ]
                            
                            
                            
                            Alamofire.request(baseUrl + "user/get_user_list", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
                                
                                if((apiresponse.response) != nil)
                                {
                                    
                                    //print(JSON(apiresponse.result.value!))
                                    
                                    tempProfiles.set(apiresponse.result.value, forKey: "otherUserProfiles")
                                    
                                    print(JSON(tempProfiles))
                                    
                                    
                                    
                                    self.window = UIWindow(frame: UIScreen.main.bounds)
                                    
                                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    
                                    let nextViewController: SwipingViewController = mainStoryboard.instantiateViewController(withIdentifier: "SwipingViewController") as! SwipingViewController
                                
                                    self.window?.rootViewController = nextViewController
                                    
                                    self.window?.makeKeyAndVisible()
                                    
                                    
                                }
                                else
                                {
                                    print("Error")
                                }
                                
                            }
                            
                            
                        }
                        
                        //------------------------------------ Code for setting the swipe cards data into the defaults End----------------- 

                        
                        /*
                         
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        //let exampleViewController: ProfileViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                        
                        let exampleViewController: SwipingViewController = mainStoryboard.instantiateViewController(withIdentifier: "SwipingViewController") as! SwipingViewController
                        
                        //SwipingViewController
                        
                        self.window?.rootViewController = exampleViewController
                        
                        self.window?.makeKeyAndVisible()
 
                        */
                    }
                    else
                    {
                        
                        
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let nextViewController: dummyViewController = mainStoryboard.instantiateViewController(withIdentifier: "dummyViewController") as! dummyViewController
                        
                        self.window?.rootViewController = nextViewController
                        
                        self.window?.makeKeyAndVisible()

                    }
                    
                    /*
                    userpersonalinfo.set(apiresponseuserdata.result.value, forKey: "userpersonalinfo")
                    
                    let ifuser2 = JSON(userpersonalinfo.object(forKey: "userpersonalinfo")!)
                    
                    if(ifuser1["linkedin_login"][0]["user_id"] == ifuser2["linkedin_login"][0]["user_id"])
                    {
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let exampleViewController: SwipingViewController = mainStoryboard.instantiateViewController(withIdentifier: "SwipingViewController") as! SwipingViewController
                        
                        self.window?.rootViewController = exampleViewController
                        
                        self.window?.makeKeyAndVisible()
                        
                    }
                    else
                    {
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let exampleViewController: dummyViewController = mainStoryboard.instantiateViewController(withIdentifier: "dummyViewController") as! dummyViewController
                        
                        self.window?.rootViewController = exampleViewController
                        
                        self.window?.makeKeyAndVisible()
                    }
 
                    */
                    
                }
                else
                {
                    print("Error")
                }
                
                
            })
 
            
            
 
            
 
            /*
            
            if(ifuser1["linkedin_login"][0]["user_id"] != JSON.null)
            {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let exampleViewController: SwipingViewController = mainStoryboard.instantiateViewController(withIdentifier: "SwipingViewController") as! SwipingViewController
            
                self.window?.rootViewController = exampleViewController
            
                self.window?.makeKeyAndVisible()
            
            }
            */
            
            
            //--------------------------- Check the user is in database or not or if manulayy deleted End -----------------------
        }
        
        
        
        
       
       
        return true
    }

 
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        
        device_token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        
        print("The device Token is = \(device_token!)")
        
        
        
        
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    
         print(error)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any] ) {
                
        let infouser = JSON(userInfo)
        
        print("The notification is \(infouser)")
        
        print(infouser["aps"]["type"])
        
        let baseUrl = "https://bulale.in/linksy/api/index.php/"
        
        if(infouser["aps"]["type"] == "match")
        {
            let temp = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
        
            if(temp == nil)
            {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextViewController: dummyViewController = mainStoryboard.instantiateViewController(withIdentifier: "dummyViewController") as! dummyViewController
            
                self.window?.rootViewController = nextViewController
            
                self.window?.makeKeyAndVisible()
            
            
            }
            else
            {
            
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MatchNotification"), object: nil, userInfo: userInfo)
            
                
                
                /*
                let ifuser1 = JSON(temp!)
            
                let parametersdata = ["user_id": ifuser1["linkedin_login"][0]["user_id"]]
            
                Alamofire.request(baseUrl+"user/get_user_details", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (apiresponseuserdata) in
                
                if((apiresponseuserdata.response) != nil)
                {
                    
                    let x = JSON(apiresponseuserdata.result.value!)
                    
                    //print(x)
                    
                    if(x["status"] == "success")
                    {
                        if let userinfo = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
                        {
                           
                            
                            let tempdata = JSON(userinfo)
                            
                            let parametersdata:[String : String] = ["user_id": tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string! ]
                            
                            
                            
                            Alamofire.request(baseUrl + "user/user_matchs", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
                                
                                if((apiresponse.response) != nil)
                                {
                                    
                                    
                                    
                                    ConnList.set(apiresponse.result.value, forKey: "ConnList")

                                    self.window = UIWindow(frame: UIScreen.main.bounds)
                                    
                                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    
                                    let nextViewController: MatchesViewController = mainStoryboard.instantiateViewController(withIdentifier: "MatchesViewController") as! MatchesViewController
                                    
                                    self.window?.rootViewController = nextViewController
                                    
                                    self.window?.makeKeyAndVisible()
                                    
                                    
                                }
                                else
                                {
                                    print("Error")
                                }
                                
                            }
                            
                            
                        }
                        
                    }
                    else
                    {
                        
                        
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let nextViewController: dummyViewController = mainStoryboard.instantiateViewController(withIdentifier: "dummyViewController") as! dummyViewController
                        
                        self.window?.rootViewController = nextViewController
                        
                        self.window?.makeKeyAndVisible()
                        
                    }
                    
                    
                }
                else
                {
                    print("Error")
                }
                
                
                })
            
                
                */
            }
            
            
            
        }
        
            
        else
        {
            
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MessageNotification"), object: userInfo, userInfo: userInfo)
            
           // NotificationCenter.default.removeObserver(NSNotification.Name(rawValue: "MessageNotification"))
            
            //NotificationCenter.default.re
            
            
             
            let temp = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
            
            if(temp == nil)
            {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextViewController: dummyViewController = mainStoryboard.instantiateViewController(withIdentifier: "dummyViewController") as! dummyViewController
                
                self.window?.rootViewController = nextViewController
                
                self.window?.makeKeyAndVisible()
                
                
            }
            else
            {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MessageNotification"), object: nil, userInfo: userInfo)
                
                
                
                
               /*
                
                let ifuser1 = JSON(temp!)
                
                let parametersdata = ["user_id": ifuser1["linkedin_login"][0]["user_id"]]
                
                Alamofire.request(baseUrl+"user/get_user_details", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (apiresponseuserdata) in
                    
                    if((apiresponseuserdata.response) != nil)
                    {
                        
                        let x = JSON(apiresponseuserdata.result.value!)
                        
                        //print(x)
                        
                        if(x["status"] == "success")
                        {
                            if let userinfo = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
                            {
                                
                                
                                let tempdata = JSON(userinfo)
                                
                                let getchatdata:[String : String] = ["user_id": tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string! , "chat_id": infouser["aps"]["chat_id"].stringValue ]
                                
                                Alamofire.request(baseUrl + "user/chat_conversation_msgs", method: HTTPMethod.post, parameters: getchatdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON
                                    { (apiresponseMsgs) in
                                        
                                        if((apiresponseMsgs.response) != nil)
                                        {
                                            print(apiresponseMsgs.result.value!)
                                            
                                            chatMsgArray.set(apiresponseMsgs.result.value, forKey: "chatMsgArray")
                                            
                                            msgsenderinfo.set(userInfo, forKey: "msgsenderinfo")
                                            
                                            self.window = UIWindow(frame: UIScreen.main.bounds)
                                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                            let nextViewController: ChatOutViewViewController = mainStoryboard.instantiateViewController(withIdentifier: "ChatOutViewViewController") as! ChatOutViewViewController
                                            
                                            self.window?.rootViewController = nextViewController
                                            
                                            self.window?.makeKeyAndVisible()
                                        }
                                }
                                
                                
                            }
                            
                        }
                        else
                        {
                            
                            
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let nextViewController: dummyViewController = mainStoryboard.instantiateViewController(withIdentifier: "dummyViewController") as! dummyViewController
                            
                            self.window?.rootViewController = nextViewController
                            
                            self.window?.makeKeyAndVisible()
                            
                        }
                        
                        
                    }
                    else
                    {
                        print("Error")
                    }
                    
                    
                })
                
                */
            }
            
           
            
        }
    
}

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

   
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        
    }

    
    
    
    
    
    
}

