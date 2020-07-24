//
//  SettingsViewController.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/23.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit
import SwiftUI

class SettingsViewController: UIHostingController<SettingsView> {
    
    init() {
        super.init(rootView: SettingsView())
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}
