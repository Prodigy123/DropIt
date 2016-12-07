//
//  DropItUIView.swift
//  DropIt
//
//  Created by 吉安 on 02/12/2016.
//  Copyright © 2016 An Ji. All rights reserved.
//

import UIKit
import CoreMotion
class DropItUIView: DrawView
{
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView:self)
    private let dropBehavior = FallingObjectBehavior()
    private let numPerRow = 10
    private var dropSize : CGSize {
        let size = bounds.size.width/CGFloat(numPerRow)
        return CGSize(width: size, height: size)
    }
    var animate = false{
        didSet{
            if animate == true{
                animator.addBehavior(dropBehavior)
                updateGravity()
            }else{
                animator.removeBehavior(dropBehavior)
            }
        }
    }
    var lastDrop: UIView?
    //    private var attachment: UIAttachmentBehavior?{
    //        willSet {
    //            if attachment != nil {
    //                animator.removeBehavior(attachment!)
    //                drawDict[BarrierName.Attachment] = nil
    //            }
    //        }
    //
    //        didSet {
    //            if attachment != nil {
    //                animator.addBehavior(attachment!)
    //                attachment!.action = { [unowned self] in
    //                    if let attachedDrop = self.attachment!.items.first as? UIView {
    //                        self.drawDict[BarrierName.Attachment] =
    //                            UIBezierPath.lineFrom(from: self.attachment!.anchorPoint, to: attachedDrop.center)
    //                    }
    //                }
    //            }
    //        }
    //    }
    //
    //
    
    
    
    
    //    func addLine(_ recognizer:UIPanGestureRecognizer){
    //        let gesturePoint = recognizer.location(in: self)
    //        switch recognizer.state{
    //        case .began:
    //            if let dropToAttachTo = lastDrop, dropToAttachTo.superview != nil {
    //                attachment = UIAttachmentBehavior(item: dropToAttachTo, attachedToAnchor: gesturePoint)
    //            }
    //            lastDrop = nil
    //        case .changed: break
    //        //update attchment
    //        default: break
    //        }
    //    }
    struct BarrierName{
        static let middleBlock = "middleblock"
        static let Attachment = "attchment"
    }
    override func layoutSubviews() {
        let path = UIBezierPath(ovalIn: CGRect(center: bounds.mid, size: dropSize))
        dropBehavior.addbarrier(path, named: BarrierName.middleBlock)
        drawDict[BarrierName.middleBlock] = path
    }
    func addDrop()
    {
        var frame = CGRect(origin: CGPoint.zero, size: dropSize)
        frame.origin.x = CGFloat.random(max: numPerRow) * dropSize.width
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor.random
        addSubview(dropView)
        lastDrop = dropView
        dropBehavior.addItem(item: dropView)
    }
    var realGravity:Bool = false{
        didSet{
            updateGravity()
        }
    }
    private let motionManegement = CMMotionManager()
    
    private func updateGravity(){
        if realGravity{
            if motionManegement.isAccelerometerAvailable && !motionManegement.accessibilityActivate(){
                motionManegement.accelerometerUpdateInterval = 0.25
                motionManegement.startAccelerometerUpdates(to: OperationQueue.main){
                    [unowned self] (data, error) in
                    if self.dropBehavior.dynamicAnimator != nil{
                        if var dx = data?.acceleration.x, var dy = data?.acceleration.y{
                            switch UIDevice.current.orientation{
                            case .portrait: dy = -dy
                            case .portraitUpsideDown: break
                            case .landscapeRight: swap(&dx, &dy)
                            case .landscapeLeft: swap(&dx, &dy); dy = -dy
                            default: dx = 0; dy = 0;
                            }
                            self.dropBehavior.gravity.gravityDirection = CGVector(dx: dx, dy: dy)
                        }
                    }else{self.motionManegement.stopAccelerometerUpdates()}
                }
            }
        }else{motionManegement.stopAccelerometerUpdates()}
    }
    var attachment: UIAttachmentBehavior?{
        willSet {
            if attachment != nil {
                animator.removeBehavior(attachment!)
                drawDict[BarrierName.Attachment] = nil
            }
        }
        didSet{
            if attachment != nil{
                animator.addBehavior(attachment!)
                attachment!.action = { [unowned self] in
                    if let attachedItem = self.attachment!.items.first as? UIView{
                        self.drawDict[BarrierName.Attachment] = UIBezierPath.lineFrom(from: self.attachment!.anchorPoint, to: attachedItem.center)
                    }
                }
            }
        }
    }
    func addLine(_ recognizer:UIPanGestureRecognizer)
    {   let gesturePoint = recognizer.location(in: self)
        switch recognizer.state{
        case .began:
            if let attachPoint = lastDrop, attachPoint.superview != nil
            {
                attachment = UIAttachmentBehavior(item: attachPoint, attachedToAnchor: gesturePoint)
            }
            lastDrop = nil
        case .changed:
            attachment?.anchorPoint = gesturePoint
        default:
            attachment = nil
        }
    }
}
