//
//  BackupViewController.swift
//  HapticDance
//
//  Created by Isabella Gomez on 11/29/23.
//

import UIKit
import CoreHaptics
import AVFoundation

class BackupViewController: UIViewController {
    
    // Set the status bar white to show up on a black background.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Force the app to use dark mode
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
    }
    
}
