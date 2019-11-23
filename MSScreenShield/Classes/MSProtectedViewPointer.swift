//
//  MSProtectedViewPointer.swift
//  ScreenRecording
//
//  Created by Claudio Madureira Silva Filho on 11/23/19.
//  Copyright © 2019 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

class MSProtectedViewPointer: NSObject {
    
    weak var protectedView: UIView?
    var shieldView: UIView
    
    required init(protectedView: UIView, shieldView: UIView) {
        self.protectedView = protectedView
        self.shieldView = shieldView
    }
    
}
