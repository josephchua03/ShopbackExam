//
//  ScrollViewExt.swift
//  ShopBackExam
//
//  Created by Joseph Chua on 3/8/19.
//  Copyright © 2019 Joseph Chua. All rights reserved.
//

import Foundation
import UIKit

//When Scroll is near end of tableview will return true
extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 40.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
