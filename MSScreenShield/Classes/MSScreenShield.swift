//
//  MSScreenShield.swift
//  ScreenRecording
//
//  Created by Claudio Madureira Silva Filho on 11/23/19.
//  Copyright © 2019 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

public class MSScreenShield: NSObject {
    
    public static var allowsPrinting: Bool = false

    public static var isScreenBeingRecorded: Bool {
        for screen in UIScreen.screens {
            if screen.isCaptured {
                return true
            }
            if screen.mirrored != nil {
                return true
            }
        }
        return false
    }
    
    public static func bind(_ listener: MSScreenshotListener) {
        self.shared.screenshotListeners.insert(listener)
    }
    
    public static func unbind(_ listener: MSScreenshotListener) {
        self.shared.screenshotListeners.remove(listener)
    }
    
    static func printSafely(_ text: String) {
        #if DEBUG
        if self.allowsPrinting {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSSS"
            print(formatter.string(from: Date()), "MSScreenShield [Log]", text)
        }
        #endif
    }
    
    static func warn(_ text: String) {
        #if DEBUG
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSSS"
        print(formatter.string(from: Date()), "MSScreenShield [Warning]", text)
        #endif
    }
    
    static let shared: MSScreenShield = .init()
    
    let shieldIdentifier: String = "ScreenRecordingShield"
    var protectedViewPointers: Set<MSProtectedViewPointer> = .init()
    private let observerPath: String = "captured"
    private var screenshotListeners: Set<MSScreenshotListener> = .init()
    
    public override init() {
        super.init()
        
        UIScreen.main.addObserver(
            self, forKeyPath: self.observerPath, options: .new, context: nil)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(screenshotTaken),
            name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
    deinit {
        UIScreen.main.removeObserver(self, forKeyPath: self.observerPath)
        NotificationCenter.default.removeObserver(self)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        let isRecording = MSScreenShield.isScreenBeingRecorded
        MSScreenShield.printSafely(isRecording ? "Screen started being recording." : "Screen stopped being recording.")
        for pointer in MSScreenShield.shared.protectedViewPointers {
            if let _protectedView = pointer.protectedView {
                let shieldView = pointer.shieldView
                shieldView.alpha = isRecording ? 1 : 0
                if shieldView.superview != _protectedView.superview {
                    MSScreenShield.warn("ProtectedView changed place. Shield updated!")
                    _protectedView.superview?.addSubview(shieldView)
                    _protectedView.superview?.addConstraints([
                        shieldView.topAnchor.constraint(equalTo: _protectedView.topAnchor),
                        shieldView.leftAnchor.constraint(equalTo: _protectedView.leftAnchor),
                        shieldView.rightAnchor.constraint(equalTo: _protectedView.rightAnchor),
                        shieldView.bottomAnchor.constraint(equalTo: _protectedView.bottomAnchor)])
                }
                if isRecording {
                    _protectedView.endEditing(false)
                }
            } else {
                MSScreenShield.shared.protectedViewPointers.remove(pointer)
                MSScreenShield.printSafely("Some protected view was deallocated. Pointer deallocated as well!")
            }
        }
    }
    
    @objc
    private func screenshotTaken() {
        for listener in self.screenshotListeners {
            listener.emit()
        }
        MSScreenShield.warn("User took a screenshot!")
    }
    
}

