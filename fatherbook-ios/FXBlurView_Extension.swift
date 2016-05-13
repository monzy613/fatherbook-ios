//
//  FXBlurView_Extension.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/13/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//
import ObjectiveC
import FXBlurView

private var animationTimerAssociatedKey: UInt8 = 0
private var fromAssociatedKey: UInt8 = 0
private var toAssociatedKey: UInt8 = 0
private var frameValueAssociatedKey: UInt8 = 0
private var completionWrapperAssociatedKey: UInt8 = 0

private let minimumInterval: NSTimeInterval = 0.005

class ClosureWrapper {
    var closure: (() -> ())?

    init(_ closure: (() -> ())?) {
        self.closure = closure
    }
}

extension FXBlurView {
    var animationTimer: NSTimer? {
        get {
            return objc_getAssociatedObject(self, &animationTimerAssociatedKey) as? NSTimer
        }
        set {
            objc_setAssociatedObject(self, &animationTimerAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    var from: CGFloat {
        get {
            return objc_getAssociatedObject(self, &fromAssociatedKey) as? CGFloat ?? 0.0
        }
        set {
            objc_setAssociatedObject(self, &fromAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    var to: CGFloat {
        get {
            return objc_getAssociatedObject(self, &toAssociatedKey) as? CGFloat ?? 0.0
        }
        set {
            objc_setAssociatedObject(self, &toAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    var frameValue: CGFloat {
        get {
            return objc_getAssociatedObject(self, &frameValueAssociatedKey) as? CGFloat ?? 0.0
        }
        set {
            objc_setAssociatedObject(self, &frameValueAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    var completionWrapper: ClosureWrapper {
        get {
            return objc_getAssociatedObject(self, &completionWrapperAssociatedKey) as? ClosureWrapper ?? ClosureWrapper(nil)
        }
        set {
            objc_setAssociatedObject(self, &completionWrapperAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    func blurAnimation(from from: CGFloat, to: CGFloat, duration: CGFloat, completion: (() -> ())? = nil) {
        if from == to {
            return
        }
        self.from = from
        self.to = to
        blurRadius = from
        let diff = to - from
        let frameCount = duration / CGFloat(minimumInterval)
        frameValue = diff / frameCount
        completionWrapper = ClosureWrapper(completion)
        animationTimer = NSTimer.scheduledTimerWithTimeInterval(minimumInterval, target: self, selector: #selector(blur), userInfo: nil, repeats: true)
    }

    func blur() {
        self.blurRadius += frameValue
        if to > from && self.blurRadius >= to{
            invalidateTimer()
        } else if to < from && self.blurRadius <= to{
            invalidateTimer()
        }
    }

    private func invalidateTimer() {
        blurRadius = to
        animationTimer?.invalidate()
        animationTimer = nil
        if let completion = completionWrapper.closure {
            completion()
        }
    }
}