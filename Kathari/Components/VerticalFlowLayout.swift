//
//  VerticalFlowLayout.swift
//  Kathari
//
//  Created by Oluwadamisi Pikuda on 28/08/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

import UIKit

public enum VerticalFlowLayoutSpacingMode {
    case fixed(spacing: CGFloat)
    case overlap(visibleOffset: CGFloat)
}

open class VerticalFlowLayout: UICollectionViewFlowLayout {

    var sideItemScale: CGFloat = 1.0 // Default no scaling
    var sideItemAlpha: CGFloat = 1.0 // Default no fading

    open var spacingMode = VerticalFlowLayoutSpacingMode.fixed(spacing: 0) // Default spacing between cells

    override open func prepare() {
        super.prepare()
        self.updateLayout()
    }

    fileprivate func updateLayout() {
        guard let collectionView = self.collectionView else { return }

        let collectionSize = collectionView.bounds.size

        let yInset = (collectionSize.height - self.itemSize.height) / 2
        let xInset = (collectionSize.width - self.itemSize.width) / 2
        self.sectionInset = UIEdgeInsets.init(
            top: yInset,
            left: xInset,
            bottom: yInset,
            right: xInset
        )

        let side = self.itemSize.width
        let scaledItemOffset =  (side - side * self.sideItemScale) / 2

        switch self.spacingMode {
        case .fixed(let spacing):
            self.minimumLineSpacing = spacing - scaledItemOffset

        case .overlap(let visibleOffset):
            let fullSizeSideItemOverlap = visibleOffset + scaledItemOffset
            let inset = xInset
            self.minimumLineSpacing = inset - fullSizeSideItemOverlap
        }
    }

    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        return attributes.map({ self.transformLayoutAttributes($0) })
    }

    fileprivate func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes)
        -> UICollectionViewLayoutAttributes {
            guard let collectionView = self.collectionView else { return attributes }

            let collectionCenter = collectionView.frame.size.height / 2
            let offset = collectionView.contentOffset.y
            let normalizedCenter = attributes.center.y - offset

            let maxDistance = self.itemSize.height + self.minimumLineSpacing
            let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
            let ratio = (maxDistance - distance)/maxDistance

            let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
            let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale

            attributes.alpha = alpha
            attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
            attributes.zIndex = Int(alpha * 10)

            return attributes
    }

    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                           withScrollingVelocity velocity: CGPoint) -> CGPoint {

        guard let collectionView = collectionView, !collectionView.isPagingEnabled,
            let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds)
            else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }

        let midSide = collectionView.bounds.size.height / 2
        let proposedContentOffsetCenterOrigin = proposedContentOffset.y + midSide

        let closest = layoutAttributes.sorted {
            abs($0.center.y - proposedContentOffsetCenterOrigin) < abs($1.center.y - proposedContentOffsetCenterOrigin)
        }.first ?? UICollectionViewLayoutAttributes()

        let targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - midSide))

        return targetContentOffset
    }
}
