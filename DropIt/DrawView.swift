//
//  DrawView.swift
//  DropIt
//
//  Created by 吉安 on 03/12/2016.
//  Copyright © 2016 An Ji. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    var drawDict = [String:UIBezierPath](){didSet{setNeedsDisplay()}}
    override func draw(_ rect: CGRect) {
        for (_,path) in drawDict{
            UIColor.darkGray.set()
            path.stroke()
            path.fill()
        }
    }
}
