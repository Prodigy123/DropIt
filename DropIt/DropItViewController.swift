//
//  DropItViewController.swift
//  DropIt
//
//  Created by 吉安 on 02/12/2016.
//  Copyright © 2016 An Ji. All rights reserved.
//

import UIKit

class DropItViewController: UIViewController
{   
    @IBOutlet weak var dropView: DropItUIView!
    {didSet
        {
        dropView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addDrop(_:))))
        dropView.addGestureRecognizer(UIPanGestureRecognizer(target: dropView, action: #selector(dropView.addLine(_:))))
        dropView.realGravity = true
        }
    }
    
    
    func addDrop(_ recognizer: UITapGestureRecognizer){
        if recognizer.state == .ended {
            dropView.addDrop()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dropView.animate = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dropView.animate = false
    }
    
}
