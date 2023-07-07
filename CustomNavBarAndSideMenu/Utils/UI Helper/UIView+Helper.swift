//
//  UIView+Helper.swift
//  CustomNavBarAndSideMenu
//
//  Created by MCOMM00042 on 06/07/23.
//

import UIKit

extension UIView {
    static func nib<T: UIView>(withType type: T.Type, name: String? = nil) -> T {
        let _name = name ?? String(describing: type)
        return Bundle.main.loadNibNamed(_name, owner: self, options: nil)?.first as! T
    }
}
