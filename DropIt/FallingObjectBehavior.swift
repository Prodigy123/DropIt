//
//  FallingObjectBehavior.swift
//  DropIt
//
//  Created by 吉安 on 03/12/2016.
//  Copyright © 2016 An Ji. All rights reserved.
//

import UIKit

class FallingObjectBehavior: UIDynamicBehavior {
    var gravity = UIGravityBehavior()
    private var collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        return collider
    }()
    private var itemBehavior: UIDynamicItemBehavior = {
        let itemBehavior = UIDynamicItemBehavior()
        itemBehavior.elasticity = 0.5
        return itemBehavior
    }()
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(itemBehavior)
    }
    func addbarrier(_ path:UIBezierPath, named name: String)
    {
        collider.removeBoundary(withIdentifier: name as NSCopying)
        collider.addBoundary(withIdentifier: name as NSCopying, for: path)
    }
    func addItem(item: UIDynamicItem)
    {
        gravity.addItem(item)
        collider.addItem(item)
        itemBehavior.addItem(item)
    }
}
