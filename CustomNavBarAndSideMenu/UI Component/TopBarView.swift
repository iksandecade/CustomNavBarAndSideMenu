//
//  TopBarView.swift
//  CustomNavBarAndSideMenu
//
//  Created by MCOMM00042 on 06/07/23.
//

import UIKit

protocol TopBarDelegate {
    func onRightMenuTapped()
    func onLeftMenuTapped()
}

class TopBarView: UIView {
    @IBOutlet weak var subTopBarView: UIStackView!
    @IBOutlet weak var mainBarView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var bigTitleLabel: UILabel!
    @IBOutlet weak var searchTextFieldHeightConstraint: NSLayoutConstraint!
    
    var delegate: TopBarDelegate?
    
    func updateTopBarHeight(height: Double) {
        var containerHeight = height
    
        if containerHeight < 64 {
            containerHeight = 64
        } else if containerHeight > 160 {
            containerHeight = 160
        }
        
        self.snp.updateConstraints { make in
            make.height.equalTo(containerHeight)
        }
        
        var searchTextFieldHeight = height - (160-36)
        
        if searchTextFieldHeight < 0 {
            searchTextFieldHeight = 0
        } else if searchTextFieldHeight > 36 {
            searchTextFieldHeight = 36
        }
        
        searchTextFieldHeightConstraint.constant = searchTextFieldHeight
    }
    
    func setAlpha(alpha: CGFloat) {
        subTopBarView.alpha = alpha
        mainBarView.alpha = 1 - alpha

        subTopBarView.isHidden = subTopBarView.alpha == 0
        mainBarView.isHidden = mainBarView.alpha == 0
    }
    
    @IBAction func rightMenuTapped(_ sender: Any) {
        delegate?.onRightMenuTapped()
    }
    
    @IBAction func leftMenuTapped(_ sender: Any) {
        delegate?.onLeftMenuTapped()
    }
}
