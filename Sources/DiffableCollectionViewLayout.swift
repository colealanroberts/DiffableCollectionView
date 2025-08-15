//
//  DiffableCollectionViewAdapter+Util.swift
//  DiffableCollectionView
//
//  Created by Cole Roberts on 4/4/25.
//

import UIKit

/// Contains layout information for a specific section.
struct DiffableCollectionViewLayout {
    /// A typealias for `UICollectionLayoutSectionOrthogonalScrollingBehavior`.
    public typealias ScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior

    ///  The direction the collection view arranges content.
    ///  - Note: The default is `list()`.
    public let composition: Composition

    /// The horizontal size of the content.
    /// - Note: The default is `unconstrained`.
    public let horizontalSize: Size

    /// The vertical spacing between the items.
    /// - Note: The default is `CGFloat.zero`.
    public let interGroupSpacing: CGFloat

    /// The content insets for an item.
    /// - Note: The default value is `NSDirectionalEdgeInsets.zero`.
    public let itemInsets: NSDirectionalEdgeInsets

    /// The content insets for the section.
    /// - Note: The default value is `NSDirectionalEdgeInsets.zero`.
    public let sectionInsets: NSDirectionalEdgeInsets

    /// - Note: The default is `unconstrained`.
    public let verticalSize: Size

    /// This initializer is intentionally internal. Please use the
    /// static utility methods for construction.
    init(
        composition: Composition = .list,
        sectionInsets: NSDirectionalEdgeInsets = .zero,
        itemInsets: NSDirectionalEdgeInsets = .zero,
        interGroupSpacing: CGFloat = .zero,
        horizontalSize: Size = .unconstrained,
        verticalSize: Size = .unconstrained
    ) {
        self.sectionInsets = sectionInsets
        self.itemInsets = itemInsets
        self.composition = composition
        self.horizontalSize = horizontalSize
        self.interGroupSpacing = interGroupSpacing
        self.verticalSize = verticalSize
    }

    public static func grid(
        columns: Int,
        sectionInsets: NSDirectionalEdgeInsets = .zero,
        itemInsets: NSDirectionalEdgeInsets = .zero,
        interGroupSpacing: CGFloat = .zero
    ) -> Self {
        .init(
            composition: .grid(columns: columns),
            sectionInsets: sectionInsets,
            itemInsets: itemInsets,
            interGroupSpacing: interGroupSpacing
        )
    }

    public static func horizontal(
        scrollingBehavior: ScrollingBehavior,
        sectionInsets: NSDirectionalEdgeInsets = .zero,
        itemInsets: NSDirectionalEdgeInsets = .zero,
        interGroupSpacing: CGFloat = .zero,
        horizontalSize: Size,
        verticalSize: Size
    ) -> Self {
        .init(
            composition: .horizontal(
                scrollingBehavior: scrollingBehavior
            ),
            sectionInsets: sectionInsets,
            itemInsets: itemInsets,
            interGroupSpacing: interGroupSpacing,
            horizontalSize: horizontalSize,
            verticalSize: verticalSize
        )
    }

    public static func list(
        sectionInsets: NSDirectionalEdgeInsets = .zero,
        interGroupSpacing: CGFloat = .zero
    ) -> Self {
        .init(
            composition: .list,
            sectionInsets: sectionInsets,
            interGroupSpacing: interGroupSpacing
        )
    }

    public static func vertical(
        sectionInsets: NSDirectionalEdgeInsets = .zero,
        itemInsets: NSDirectionalEdgeInsets = .zero,
        interGroupSpacing: CGFloat = .zero,
        horizontalSize: Size = .unconstrained,
        verticalSize: Size = .unconstrained
    ) -> Self {
        .init(
            composition: .vertical,
            sectionInsets: sectionInsets,
            interGroupSpacing: interGroupSpacing,
            horizontalSize: horizontalSize,
            verticalSize: verticalSize
        )
    }

    public static func section(
        _ section: NSCollectionLayoutSection
    ) -> Self {
        .init(composition: .section(section))
    }
}

// MARK: - DiffableCollectionViewLayout+Composition

extension DiffableCollectionViewLayout {
    enum Composition {
        /// Arranges its content uniformly in a grid
        /// with the specified number of columns.
        case grid(columns: Int)

        /// Arranges its content horizontally.
        /// - Parameters:
        ///   - scrollingBehavior: The scrolling behavior, i.e. continuous, paged, etc.
        case horizontal(
            scrollingBehavior: DiffableCollectionViewLayout.ScrollingBehavior
        )

        /// Arranges its content in a vertical list.
        case list

        /// Arranges its content vertically.
        case vertical

        /// Provides full flexibility to the caller when describing the shape of the content.
        case section(NSCollectionLayoutSection)
    }
}

// MARK: - DiffableCollectionViewLayout+Size

extension DiffableCollectionViewLayout {
    /// The size of the section.
    /// - Note: If the direction is `.vertical`, the section
    /// consumes as much space as necessary.
    enum Size {
        /// The section content will fill all necessary space.
        case unconstrained

        /// The content is an exact size.
        case absolute(CGFloat)

        /// The content is a fractional size.
        /// - Note: Values must be between 0.0 -> 1.0.
        case fraction(Double)

        /// The content sizes itself.
        case estimated(Double)
    }
}

// MARK: - NSDirectionalEdgeInsets+Util

/// A utility extension to simplify the creation of `NSDirectionalEdgeInsets` with uniform, horizontal, or vertical values.
extension NSDirectionalEdgeInsets {

    /// Creates edge insets where all sides (top, leading, bottom, trailing) are equal.
    /// - Parameter value: The inset value to apply to all sides.
    /// - Returns: A `NSDirectionalEdgeInsets` instance with uniform insets.
    static func uniform(_ value: CGFloat) -> Self {
        .init(
            top: value,
            leading: value,
            bottom: value,
            trailing: value
        )
    }

    /// Creates edge insets where only the horizontal sides (leading and trailing) are set.
    /// - Parameter value: The inset value to apply to the leading and trailing sides.
    /// - Returns: A `NSDirectionalEdgeInsets` instance with horizontal insets.
    static func horizontal(_ value: CGFloat) -> Self {
        .init(
            top: 0,
            leading: value,
            bottom: 0,
            trailing: value
        )
    }

    /// Creates edge insets where only the vertical sides (top and bottom) are set.
    /// - Parameter value: The inset value to apply to the top and bottom sides.
    /// - Returns: A `NSDirectionalEdgeInsets` instance with vertical insets.
    static func vertical(_ value: CGFloat) -> Self {
        .init(
            top: value,
            leading: 0,
            bottom: value,
            trailing: 0
        )
    }
}
