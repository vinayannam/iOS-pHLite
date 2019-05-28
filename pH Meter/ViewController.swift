//
//  ViewController.swift
//  pH Meter
//
//  Created by A.S.D.Vinay on 06/01/17.
//  Copyright © 2017 A.S.D.Vinay. All rights reserved.
//

import UIKit
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}

class ViewController: UIViewController {
    var selected_color: UIColor? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        let V1:View1 = View1(nibName:"View1", bundle:nil)
        let V2:View2 = View2(nibName:"View2", bundle:nil)
        let V3:View3 = View3(nibName:"View3", bundle:nil)
        let V4:View4 = View4(nibName:"View4", bundle:nil)
        
        self.addChildViewController(V1)
        self.scrollViewer.addSubview(V1.view)
        V1.didMove(toParentViewController: self)
        
        self.addChildViewController(V2)
        self.scrollViewer.addSubview(V2.view)
        V2.didMove(toParentViewController: self)
        
        self.addChildViewController(V3)
        self.scrollViewer.addSubview(V3.view)
        V3.didMove(toParentViewController: self)
        self.addChildViewController(V3)
        
        self.scrollViewer.addSubview(V4.view)
        V4.didMove(toParentViewController: self)
        self.addChildViewController(V4)
        
        var V2Frame: CGRect = V1.view.frame
        V2Frame.origin.x = self.view.frame.width
        V2.view.frame = V2Frame
        
        var V3Frame: CGRect = V1.view.frame
        V3Frame.origin.y =  self.view.frame.height
        V3.view.frame = V3Frame
        
        var V4Frame: CGRect = V1.view.frame
        V4Frame.origin.x = self.view.frame.width
        V4Frame.origin.y =  self.view.frame.height
        V4.view.frame = V4Frame
        
        self.scrollViewer.contentSize = CGSize(self.view.frame.width * 2,self.view.frame.height * 2)
        
//        selected_color = V2.color
//        V3.view.backgroundColor = selected_color
//        print(selected_color)
        
        
    }
    


  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var scrollViewer: UIScrollView!

}

