//
//  DDCycleScrollView.swift
//  DDCycleScrollView
//
//  Created by kongxc on 15/8/31.
//  Copyright (c) 2015年 kongxc. All rights reserved.
//

import Foundation
import UIKit

private let defaultTimeInterval = 2.5
private let pageControlMargin:CGFloat = 20
private let defaultCurrentPageIndicatorTintColor = UIColor.orangeColor()
private let defaultPageIndicatorTintColor = UIColor.blueColor()

public protocol DDCycleScrollViewDelegate :NSObjectProtocol{
    
    func didSelectCurrentPage(index : Int)
    func numberOfPages() -> Int
    func currentPageViewIndex(index:Int) -> String
}

class DDCycleScrollView: UIView,UIScrollViewDelegate {
    
    //**  property  */
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var timer: NSTimer?
    var currentImageView = UIImageView()
    var lastImageView = UIImageView()
    var nextImageView = UIImageView()
    var totalPages:Int!
    weak var delegate : DDCycleScrollViewDelegate? {
       
        didSet{
            
            totalPages = delegate?.numberOfPages()
            scrollView.scrollEnabled = !(totalPages == 1)
            setScrollViewOfImage()
            
            self.pageControl = UIPageControl(frame: CGRectMake(self.frame.size.width - pageControlMargin * CGFloat(totalPages), self.frame.size.height - 30, pageControlMargin * CGFloat(totalPages), pageControlMargin))
            pageControl.hidesForSinglePage = true
            pageControl.numberOfPages = totalPages
            pageControl.currentPageIndicatorTintColor = defaultCurrentPageIndicatorTintColor
            pageControl.pageIndicatorTintColor = defaultPageIndicatorTintColor
            pageControl.backgroundColor = UIColor.clearColor()
            self.addSubview(pageControl)
        }
    }
    
    var currentPageIndex : Int! {
        
        didSet{
            self.pageControl.currentPage = currentPageIndex
        }
    }

    /**
    *  init
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // default is 0
        currentPageIndex = 0
        setUpCycleScrollView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private func setUpCycleScrollView(){
        
        self.scrollView = UIScrollView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0)
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.pagingEnabled = true
        scrollView.backgroundColor = UIColor.greenColor()
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
        
        self.setImageViewWithIndex(index: 1, imageView: currentImageView)
        self.setImageViewWithIndex(index: 0, imageView: lastImageView)
        self.setImageViewWithIndex(index: 2, imageView: nextImageView)

        scrollView.setContentOffset(CGPointMake(self.frame.size.width, 0), animated: false)
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(defaultTimeInterval, target: self, selector: "timerAction", userInfo: nil, repeats: true)
        
    }
    func timerAction(){
        
        scrollView.setContentOffset(CGPointMake(self.frame.size.width*2, 0), animated: true)
    }
    
    private func setImageViewWithIndex(#index: Int,imageView: UIImageView!){
        
        imageView.frame = CGRectMake(self.frame.size.width * CGFloat(index), 0, self.frame.size.width, self.frame.size.height)
        imageView.userInteractionEnabled = true
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        scrollView.addSubview(imageView)
        
        if imageView == self.currentImageView {
            
            var imageTap = UITapGestureRecognizer(target: self, action: Selector("imageTapAction:"))
            currentImageView.addGestureRecognizer(imageTap)
        }
        
    }
    func imageTapAction(tap: UITapGestureRecognizer){
        
        delegate?.didSelectCurrentPage(currentPageIndex)
    
    }
   private func setScrollViewOfImage(){
    
    
        currentImageView.image = UIImage(named: (delegate?.currentPageViewIndex(currentPageIndex))!)
    
        lastImageView.image = UIImage(named: (delegate?.currentPageViewIndex(getLastImageIndex(currentPageIndex)))!)
            
        nextImageView.image = UIImage(named:( delegate?.currentPageViewIndex(getNextImageIndex(currentPageIndex)))!)
    
    }
    private func getLastImageIndex(currentImageIndex: Int) -> Int{
        var tempIndex = currentImageIndex - 1
        if tempIndex == -1 {
            return totalPages - 1
        }else{
            return tempIndex
        }
    }
    
    private func getNextImageIndex(currentImageIndex: Int) -> Int
    {
        var tempIndex = currentImageIndex + 1
        return tempIndex < totalPages ? tempIndex : 0
    }
    
    /**
    *  scrollViewDelegate
    */
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        timer?.invalidate()
        timer = nil
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        var offset = scrollView.contentOffset.x
        if offset == 0 {
            self.currentPageIndex = self.getLastImageIndex(self.currentPageIndex)
        }else if offset == self.frame.size.width * 2 {
            self.currentPageIndex = self.getNextImageIndex(self.currentPageIndex)
        }
        self.setScrollViewOfImage()
        scrollView.setContentOffset(CGPointMake(self.frame.size.width, 0), animated: false)
        if timer == nil {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(defaultTimeInterval, target: self, selector: "timerAction", userInfo: nil, repeats: true)
        }
    }
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(scrollView)
    }
    
}