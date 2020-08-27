//
//  UIScrollView+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 30/06/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }

    func scrollTo(view: UIView, animated: Bool) {
        guard let superview = view.superview  else { return }
        let childVerticalCoordinate = superview.convert(view.frame.origin, to: self).y
        let bottomVerticalOffset = self.contentSize.height - self.bounds.size.height
        let verticalScrollPoint = min(childVerticalCoordinate, bottomVerticalOffset)

        self.setContentOffset(CGPoint(x: 0, y: verticalScrollPoint), animated: animated)
    }

    func scrollToTop(animated: Bool) {
        let offset = CGPoint(x: -adjustedContentInset.left, y: -adjustedContentInset.top)
        self.setContentOffset(offset, animated: animated)
    }
}
