//
//  MSScreenshotListener.swift
//  ScreenRecording
//
//  Created by Claudio Madureira Silva Filho on 11/23/19.
//  Copyright © 2019 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

public class MSScreenshotListener: NSObject {

    let handler: (() -> Void)
    
    public required init(handler: @escaping () -> Void) {
        self.handler = handler
    }
    
    func emit() {
        self.handler()
    }
    
}
