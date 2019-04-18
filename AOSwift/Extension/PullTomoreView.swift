//
//  PullTomoreView.swift
//  HongyuanProperty
//
//  Created by 刘洪彬 on 2019/4/18.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit
struct PullToMoreConst {
    static let tag = 810
    static let alpha = true
    static let height: CGFloat = 80
    static let imageName: String = "pullToMorearrow.png"
    static let animationDuration: Double = 0.4
    static let fixedButtom = true // PullToMoreView fixed Top
}

class PullToMoreOption {
    var backgroundColor = UIColor.clear
    var indicatorColor = UIColor.gray
    var autoStopTime: Double = 0.7 // 0 is not auto stop
    var fixedSectionFooter = false  // Update the content inset for fixed section headers
}

open class PullToMoreView: UIView {
    enum PullToMoreState {
        case normal
        case pulling
        case refreshing
    }
    
    // MARK: Variables
    let contentOffsetKeyPath = "contentOffset"
    var kvoContext = ""
    
    fileprivate var options: PullToMoreOption!
    fileprivate var backgroundView: UIView!
    fileprivate var arrow: UIImageView!
    fileprivate var indicator: UIActivityIndicatorView!
    fileprivate var scrollViewBounces: Bool = false
    fileprivate var scrollViewInsets: UIEdgeInsets = UIEdgeInsets.zero
    fileprivate var previousOffset: CGFloat = 0
    fileprivate var refreshCompletion: (() -> ()) = {}
    
    var state: PullToMoreState = PullToMoreState.normal {
        didSet {
            if self.state == oldValue {
                return
            }
            switch self.state {
            case .normal:
                stopAnimating()
            case .refreshing:
                startAnimating()
            default:
                break
            }
        }
    }
    
    // MARK: UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(options: PullToMoreOption, frame: CGRect, refreshCompletion :@escaping (() -> ())) {
        self.init(frame: frame)
        self.options = options
        self.refreshCompletion = refreshCompletion
        
        self.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.backgroundView.backgroundColor = self.options.backgroundColor
        self.backgroundView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        self.addSubview(backgroundView)
        
        self.arrow = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        self.arrow.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin]
        self.arrow.image = UIImage(named: PullToMoreConst.imageName)
        self.addSubview(arrow)
        
        self.indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        self.indicator.bounds = self.arrow.bounds
        self.indicator.autoresizingMask = self.arrow.autoresizingMask
        self.indicator.hidesWhenStopped = true
        self.indicator.color = options.indicatorColor
        self.addSubview(indicator)
        
        self.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.arrow.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        self.indicator.center = self.arrow.center
    }
    
    open override func willMove(toSuperview superView: UIView!) {
        
        superview?.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &kvoContext)
        
        if let scrollView = superView as? UIScrollView {
            scrollView.addObserver(self, forKeyPath: contentOffsetKeyPath, options: .initial, context: &kvoContext)
        }
    }
    
    deinit {
        if let scrollView = superview as? UIScrollView {
            scrollView.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &kvoContext)
        }
    }
    
    // MARK: KVO
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (context == &kvoContext && keyPath == contentOffsetKeyPath) {
            if let scrollView = object as? UIScrollView {
                
                // Debug
                //println(scrollView.contentOffset.y)
                
                let offsetWithoutInsets = self.previousOffset + self.scrollViewInsets.top
                
                // Update the content inset for fixed section headers
                if self.options.fixedSectionFooter && self.state == .refreshing {
                    if (scrollView.contentOffset.y > 0) {
                        scrollView.contentInset = UIEdgeInsets.zero;
                    }
                    return
                }
                
                // Alpha set
                if PullToMoreConst.alpha {
                    var alpha = fabs(offsetWithoutInsets) / (self.frame.size.height + 30)
                    if alpha > 0.8 {
                        alpha = 0.8
                    }
                    self.arrow.alpha = alpha
                }
                
                // Backgroundview frame set
                if PullToMoreConst.fixedButtom {
                    if PullToMoreConst.height < fabs(offsetWithoutInsets) {
                        self.backgroundView.frame.size.height = fabs(offsetWithoutInsets)
                    } else {
                        self.backgroundView.frame.size.height =  PullToMoreConst.height
                    }
                } else {
                    self.backgroundView.frame.size.height = PullToMoreConst.height + fabs(offsetWithoutInsets)
                    self.backgroundView.frame.origin.y = -fabs(offsetWithoutInsets)
                }
                
//                debugPrint(offsetWithoutInsets,self.frame.size.height,scrollView.contentInset)
                // Pulling State Check
                if (offsetWithoutInsets < -self.frame.size.height) {
                    
                    // pulling or refreshing
                    if (scrollView.isDragging == false && self.state != .refreshing) {
                        self.state = .refreshing
                    } else if (self.state != .refreshing) {
                        self.arrowRotation()
                        self.state = .pulling
                    }
                } else if (self.state != .refreshing && offsetWithoutInsets < 0) {
                    // normal
                    self.arrowRotationBack()
                }
                self.previousOffset = scrollView.contentOffset.y
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: private
    
    fileprivate func startAnimating() {
        self.indicator.startAnimating()
        self.arrow.isHidden = true
        
        if let scrollView = superview as? UIScrollView {
            scrollViewBounces = scrollView.bounces
            scrollViewInsets = scrollView.contentInset
            
            var insets = scrollView.contentInset
            insets.top += self.frame.size.height
            scrollView.contentOffset.y = self.previousOffset
            scrollView.bounces = false
            UIView.animate(withDuration: PullToMoreConst.animationDuration, delay: 0, options:[], animations: {
                scrollView.contentInset = insets
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: -insets.top)
            }, completion: {finished in
                if self.options.autoStopTime != 0 {
                    let time = DispatchTime.now() + Double(Int64(self.options.autoStopTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: time) {
                        self.state = .normal
                    }
                }
                self.refreshCompletion()
            })
        }
    }
    
    fileprivate func stopAnimating() {
        self.indicator.stopAnimating()
        self.arrow.transform = CGAffineTransform.identity
        self.arrow.isHidden = false
        
        if let scrollView = superview as? UIScrollView {
            scrollView.bounces = self.scrollViewBounces
            UIView.animate(withDuration: PullToMoreConst.animationDuration, animations: { () -> Void in
                scrollView.contentInset = self.scrollViewInsets
            }, completion: { (Bool) -> Void in
                
            })
        }
    }
    
    fileprivate func arrowRotation() {
        UIView.animate(withDuration: 0.2, delay: 0, options:[], animations: {
            // -0.0000001 for the rotation direction control
            self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI-0.0000001))
        }, completion:nil)
    }
    
    fileprivate func arrowRotationBack() {
        UIView.animate(withDuration: 0.2, delay: 0, options:[], animations: {
            self.arrow.transform = CGAffineTransform.identity
        }, completion:nil)
    }
}

extension UIScrollView {
    
    fileprivate var pullToMoreView: PullToMoreView? {
        get {
            let pullToMoreView = viewWithTag(PullToMoreConst.tag)
            return pullToMoreView as? PullToMoreView
        }
    }
    
    func addPullToMore(_ refreshCompletion :@escaping (() -> ())) {
        self.addPullToMore(PullToMoreOption(), refreshCompletion: refreshCompletion)
    }
    
    func addPullToMore(_ options: PullToMoreOption = PullToMoreOption(), refreshCompletion :@escaping (() -> ())) {
        let refreshViewFrame = CGRect(x: 0, y: -PullToMoreConst.height, width: self.frame.size.width, height: PullToMoreConst.height)
        let refreshView = PullToMoreView(options: options, frame: refreshViewFrame, refreshCompletion: refreshCompletion)
        refreshView.setTag(PullToMoreConst.tag)
        addSubview(refreshView)
    }
    
    func startPullToMore() {
        pullToMoreView?.state = .refreshing
    }
    
    func stopPullToMore() {
        pullToMoreView?.state = .normal
    }
    
    // If you want to PullToMoreView fixed top potision, Please call this function in scrollViewDidScroll
    func fixedPullToMoreViewForDidScroll() {
        if PullToMoreConst.fixedButtom {
            if self.contentOffset.y < -PullToMoreConst.height {
                if var frame = pullToMoreView?.frame {
                    frame.origin.y = self.contentOffset.y
                    pullToMoreView?.frame = frame
                }
            } else {
                if var frame = pullToMoreView?.frame {
                    frame.origin.y = -PullToMoreConst.height
                    pullToMoreView?.frame = frame
                }
            }
        }
    }
}
