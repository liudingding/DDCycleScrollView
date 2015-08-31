//
//  ViewController.swift
//  DDCycleScrollView
//
//  Created by kongxc on 15/8/31.
//  Copyright (c) 2015年 kongxc. All rights reserved.
//

import UIKit

class ViewController: UIViewController,DDCycleScrollViewDelegate {

    
    var imageArray :[String!] = ["meinv1.jpg","meinv2.jpg","meinv3.jpg","meinv4.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
    
        var cycleScrollView = DDCycleScrollView(frame: CGRectMake((view.frame.width - 250)/2, 64, 250, 300))
        cycleScrollView.backgroundColor = UIColor.blueColor()
        cycleScrollView.delegate = self
        view.addSubview(cycleScrollView)
        
    }
    func numberOfPages() -> Int {
        
        return imageArray.count;
    }
    func currentPageViewIndex(index: Int) -> String {
        
        return imageArray[index]
    }
    func didSelectCurrentPage(index: Int) {
        
        println("\(index)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

