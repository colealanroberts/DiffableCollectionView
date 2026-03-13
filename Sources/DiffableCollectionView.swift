//
//  DiffableCollectionView.swift
//  DiffableCollectionView
//
//  Created by Cole Roberts on 4/4/25.
//

import SwiftUI
import UIKit

/// A SwiftUI wrapper for `UICollectionView`, allowing the use of a declarative API to manage and display collection-based content with custom cells, powered by SwiftUI with the performance of UIKit.
///
/// `CollectionView` is a generic `UIViewRepresentable` that supports dynamic content updates and
/// customization through properties and a cell-building closures.
///
/// - Parameters:
///   - Section: The type representing sections in the collection view. Must conform to `Hashable`.
///   - ID: The type representing unique identifiers for each item. Must conform to `Hashable`.
///   - V: The SwiftUI `View` used as a cell representation.
///
/// ## Example Usage:
/// ```swift
/// ```
///
public struct DiffableCollectionView<Section: Hashable, ID: Hashable, Cell: View>: UIViewRepresentable {

    // MARK: - Private Properties

    let content: [DiffableCollectionViewContent<Section, ID>]
    let properties: DiffableCollectionViewProperties<Section, ID>
    let cellBuilder: (Section, ID) -> Cell

    // MARK: - Init

    public init(
        _ content: [DiffableCollectionViewContent<Section, ID>],
        @ViewBuilder cellBuilder: @escaping (_ section: Section, _ item: ID) -> Cell,
        configure: (inout DiffableCollectionViewProperties<Section, ID>) -> Void = { _ in }
    ) {
        var properties = DiffableCollectionViewProperties<Section, ID>()
        configure(&properties)
        self.properties = properties
        self.content = content
        self.cellBuilder = cellBuilder
    }

    // MARK: - Public Methods

    public func makeCoordinator() -> DiffableCollectionViewAdapter<Section, ID, Cell> {
        let layoutProvider = DiffableCollectionViewLayoutProvider<Section, ID>(
            content: content,
            properties: properties
        )

        return DiffableCollectionViewAdapter<Section, ID, Cell>(
            layoutProvider: layoutProvider,
            properties: properties,
            cellBuilder: cellBuilder
        )
    }

    public func makeUIView(context: Context) -> UICollectionView {
        context.coordinator.collectionView
    }

    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        context.coordinator.performSnapshotUpdates(
            content,
            onWillPerformUpdates: { eventPair in
                properties.stateObserver.onWillPerformUpdates?(eventPair)
            }
        )
    }
}
