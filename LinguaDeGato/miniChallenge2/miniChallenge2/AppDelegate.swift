//
//  AppDelegate.swift
//  miniChallenge2
//
//  Created by Kobayashi on 6/11/15.
//  Copyright (c) 2015 Kobayashi. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // NavigationBar can have dark colors and light colors
        // when dark is true, the content of StatusBar is white
        
        let pageController = UIPageControl.appearance()
        pageController.pageIndicatorTintColor = UIColor.lightGray
        pageController.currentPageIndicatorTintColor = UIColor.bluePalete()
        pageController.backgroundColor = UIColor.white
        
        UINavigationBar.appearance().barStyle = .black
        
        if let _ = UserDefaults.standard.value(forKey: "firstTime") {
            //do nothing
        } else {
            UserDefaults.standard.setValue(true, forKey: "firstTime")
            UserDefaults.standard.synchronize()
        }
        
        //set audio session
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryAmbient, with: AVAudioSessionCategoryOptions.mixWithOthers)
            try audioSession.setActive(true)
        }
        catch {
            print(error)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        if window != nil {
            let navigation = window!.rootViewController as! UINavigationController
            let top = navigation.topViewController
            
            if let creationController = top as? CreateCrosswordViewController {
                
                if creationController.recordingAudio {
                    creationController.finishRecording(false)
                }
            }
        }
        
        AudioCluePlayer.stopAudio()
        do {
            try AVAudioSession.sharedInstance().setActive(false, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
        }
        catch {
            //error handling
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryAmbient, with: AVAudioSessionCategoryOptions.mixWithOthers)
            try audioSession.setActive(true)
        }
        catch {
            print(error)
        }
        
        //Background music: off
//        if !MusicSingleton.sharedMusic().isMusicMute {
//            MusicSingleton.sharedMusic().playBackgroundAudio(true)
//        }
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

