//
//  UIView-Extension.swift
//  ScreenRecording
//
//  Created by Claudio Madureira Silva Filho on 11/23/19.
//  Copyright © 2019 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

public extension UIView {
    
    /// Be careful, this must be called only after view having a superview.
    func addShield(color: UIColor = .black) {
        if MSScreenShield.shared.protectedViewPointers.first(where: { $0.protectedView == self }) != nil{
            MSScreenShield.warn("Tried to add shield to a view again!")
            return
        }
        let view = UIView()
        view.backgroundColor = color
        view.frame = self.bounds
        view.restorationIdentifier = MSScreenShield.shared.shieldIdentifier
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = self.layer.masksToBounds
        view.layer.cornerRadius = self.layer.cornerRadius
        self.superview?.addSubview(view)
        self.superview?.addConstraints([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leftAnchor.constraint(equalTo: self.leftAnchor),
            view.rightAnchor.constraint(equalTo: self.rightAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
        view.alpha = MSScreenShield.isScreenBeingRecorded ? 1 : 0
        let pointer = MSProtectedViewPointer(protectedView: self, shieldView: view)
        MSScreenShield.shared.protectedViewPointers.insert(pointer)
        MSScreenShield.printSafely("Added shield to a view.")
    }
   
    func removeShield() {
        guard let pointer = MSScreenShield.shared.protectedViewPointers.first(where: { $0.protectedView == self }) else { return }
        MSScreenShield.shared.protectedViewPointers.remove(pointer)
        MSScreenShield.printSafely("Removed shield from a view.")
    }
    
}
