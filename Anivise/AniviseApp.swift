//
//  AniviseApp.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 5/10/2024.
//

import SwiftUI
import GoogleSignIn
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            FirebaseApp.configure()

    return true
  }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
    
}

@main
struct AniviseApp: App {
    let persistenceController = PersistenceController.shared
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView().onOpenURL { url in
            // Handle Google Oauth URL
                GIDSignIn.sharedInstance.handle(url)
            }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
