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
import GooglePlaces
import GoogleMaps
import CoreData
import UserNotifications


var device_token:String? = nil

var latMagnitude:Double? = nil
var longMagnitude:Double? = nil

var newMatchCount:String? = nil

var badgeCount:Int = 0


@available(iOS 10.0, *)
@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate,UNUserNotificationCenterDelegate{

    var window: UIWindow?

    
    
    var locationManager=CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let mylocation = locations.last
        
        
        //mylocation!.coordinate.latitude, mylocation!.coordinate.longitude
        
        latMagnitude = mylocation!.coordinate.latitude.magnitude
        longMagnitude = mylocation!.coordinate.longitude.magnitude
        
       
        locationManager.stopUpdatingLocation()
        
    }
    
    
    
       func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //setting the badge count to 0 again after launching the app..
        
        badgeCount = 0
        
        GMSServices.provideAPIKey("AIzaSyBk58NzROjSlhlnb5mhZqK2eUwRXITJulw")
        
        //code to egt current coordinates...
        
        //mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera2)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
        
        //---------------Push notification settings start---------------
        
        
        /*
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                
            }
        }
        else if #available(iOS 11.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            //UIApplication.shared.registerForRemoteNotifications()
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        
        */
        
        
       
        if(UserDefaults.standard.bool(forKey: "SoundFlag") == true)
        {
            let notificationType1: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
            
            let pushNotificationSettings = UIUserNotificationSettings(types: notificationType1, categories: nil)
            
            //UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
            
            application.registerUserNotificationSettings(pushNotificationSettings)
            
        }
        else
        {
            let notificationType1: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge]
            
            let pushNotificationSettings = UIUserNotificationSettings(types: notificationType1, categories: nil)
            
            //UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
            
            application.registerUserNotificationSettings(pushNotificationSettings)
            
        }
        
        
        application.registerForRemoteNotifications()
 
        application.applicationIconBadgeNumber = badgeCount
 
        
        
        /*
        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
            // Enable or disable features based on authorization
            
        }
        application.registerForRemoteNotifications()
         */
       
       
        
        //---------------Push notification settings stop----------------
        
        
        
        
        let temp = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
        
        if(temp == nil)
        {
            //--------------------------- check the user if user is already logged in ---------------------
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController: UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "LinksyLogin") as! UINavigationController
            
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
            
            let baseUrl = "http://linksy.co/api/index.php/"
            
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
                            let baseUrl = "http://linksy.co/api/index.php/"
                            
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
                                    
                                    
                                    //let nextViewController: SwipingViewController = mainStoryboard.instantiateViewController(withIdentifier: "SwipingViewController") as! SwipingViewController
                                    
                                    
                                    let nextViewController: UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "Swipecard") as! UINavigationController
                                    
                                    
                                    self.window?.rootViewController = nextViewController
                                    
                                    self.window?.makeKeyAndVisible()
                                    
                                    
                                }
                                else
                                {
                                    print("Error")
                                    
                                    let alert = UIAlertController(title: "Error 404", message: "Please check your network Connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    
                                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
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
                        let nextViewController: UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "LinksyLogin") as! UINavigationController
                        
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
                    
                    let alert = UIAlertController(title: "Error 404", message: "Please check your network Connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    
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
  
    
    /*
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("DID RECEIVE NOTIFICATION")
        completionHandler()
        
        print(response)
        
    }
 */
    
    
    /*
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("willPresent")
        
        completionHandler([.alert, .badge, .sound])
        
    }
    */

 
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        
        device_token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        
        print("The device Token is = \(device_token!)")
        
        
        
        
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    
         print(error)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any] ) {
        
        badgeCount = badgeCount + 1
                
        let infouser = JSON(userInfo)
        
        print("The notification is \(infouser)")
        
        print(infouser["aps"]["type"])
        
        let baseUrl = "http://linksy.co/api/index.php/"
        
        if(infouser["aps"]["type"] == "match")
        {
            let temp = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
        
            if(temp == nil)
            {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextViewController: UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "LinksyLogin") as! UINavigationController
            
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
            
           // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MessageNotification"), object: userInfo, userInfo: userInfo)
            
           // NotificationCenter.default.removeObserver(NSNotification.Name(rawValue: "MessageNotification"))
            
            //NotificationCenter.default.re
            
            
             
            let temp = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
            
            if(temp == nil)
            {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextViewController: UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "LinksyLogin") as! UINavigationController
                
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
    
    //------------------------------ method for local database using cordata
    
    
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
    
     let container = NSPersistentContainer(name: "LinksyDemo")
     container.loadPersistentStores(completionHandler: { (storeDescription, error) in
     if let error = error as NSError? {
     
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
     })
     
        return container
     }()
     
     // MARK: - Core Data Saving support
     
    @available(iOS 10.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
                do {
                    try context.save()
                    }
                catch {
     
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
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

