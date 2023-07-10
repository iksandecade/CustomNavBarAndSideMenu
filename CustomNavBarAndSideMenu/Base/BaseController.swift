//
//  BaseController.swift
//  CustomNavBarAndSideMenu
//
//  Created by MCOMM00042 on 06/07/23.
//

import UIKit
import SnapKit
import SideMenu

class BaseController: UIViewController {
    @IBOutlet var container: UIStackView?
    @IBOutlet var scrollView: UIScrollView?
    
    lazy internal var containerView = UIView()
    lazy internal var topBarSpacerHeight = UIView()
    //MARK: Init TopBarView
    lazy var topBarview = UIView.nib(withType: TopBarView.self) as TopBarView
    
    //MARK: Init Side Menu
    lazy internal var leftMenu = SideMenuNavigationController(rootViewController: LeftMenuViewController())
    lazy internal var rightMenu = SideMenuNavigationController(rootViewController: RightMenuViewController())
    
    var previousOffset: CGPoint?
    
    @IBInspectable var containerBackground: UIColor? {
        didSet {
            container?.backgroundColor = containerBackground
        }
    }
    
    //MARK: Ovveride Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let container {
            view.backgroundColor = containerBackground ?? .white
            
            view.addSubview(containerView)
            containerView.snp.makeConstraints { make in
                make.leading.trailing.equalTo(view)
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.bottom.equalToSuperview()
            }
            
            container.removeFromSuperview()
            containerView.addSubview(container)
            container.snp.makeConstraints { make in
                make.leading.trailing.top.bottom.equalToSuperview()
            }
        }
        
        setupSideMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: Helper
    func setupTopBar(title: String) {
        containerView.addSubview(topBarview)
        topBarview.snp.makeConstraints { make in
            make.height.equalTo(160) //MARK: original height of topBarView
            make.top.leading.trailing.equalToSuperview()
        }
        
        topBarview.delegate = self
        
        //MARK: dont forget to add this spacer, if this spacer doesnt init then topbarview will not show
        topBarSpacerHeight.backgroundColor = .clear
        container?.insertArrangedSubview(topBarSpacerHeight, at: 0)
        topBarSpacerHeight.snp.makeConstraints({ $0.height.equalTo(160) })
    }
    
    private func setupSideMenu() {
        SideMenuManager.default.rightMenuNavigationController = rightMenu
        SideMenuManager.default.leftMenuNavigationController = leftMenu
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
    
    func updateTopBar(scrollView: UIScrollView, isEndedDragging: Bool = false) {
        var topBarHeight = topBarview.frame.height
        
        let currentOffset = scrollView.contentOffset
        
        if let startOffset = previousOffset {
            let delta = abs((startOffset.y - currentOffset.y))
            
            if currentOffset.y > startOffset.y, currentOffset.y > .zero {
                var newHeight = topBarHeight - delta
                
                if newHeight < 64 {
                    newHeight = 64
                }
                
                topBarHeight = newHeight
            } else if currentOffset.y < startOffset.y, currentOffset.y <= 160 {
                var newHeight = topBarHeight + delta
                
                if newHeight > 160 {
                    newHeight = 160
                }
                
                topBarHeight = newHeight
            }
            
            previousOffset = scrollView.contentOffset
            
            if isEndedDragging {
                if topBarHeight < 80 { //MARK: condition for bigTitleLabel height < 25%
                    topBarHeight = 64
                } else if (topBarHeight - (160-36)) < 10 { //MARK: condition for searchTextField < 25%
                    topBarHeight = 124
                } else { //MARK: condition to normal height for subTopBar
                    topBarHeight = 160
                }
            }
            
            print("topbarheight \(topBarHeight)")
            topBarSpacerHeight.snp.updateConstraints { make in
                make.height.equalTo(topBarHeight)
            }
            
            topBarview.updateTopBarHeight(height: topBarHeight)
            
            if topBarHeight < 124 {
                topBarview.setAlpha(alpha: (topBarHeight-64)/60)
            } else {
                topBarview.setAlpha(alpha: 1)
            }
            
            if isEndedDragging {
                animateTopViewHeight()
            } else {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func hideSearchBar() {
        topBarSpacerHeight.snp.updateConstraints { make in
            make.height.equalTo(124)
        }
        
        topBarview.updateTopBarHeight(height: 124)
        
        topBarview.setAlpha(alpha: 1)
    }
    
    private func animateTopViewHeight() {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

extension BaseController: TopBarDelegate {
    func onRightMenuTapped() {
        present(rightMenu, animated: true)
    }
    
    func onLeftMenuTapped() {
        present(leftMenu, animated: true)
    }
    
    
}
