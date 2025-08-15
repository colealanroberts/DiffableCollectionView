//
//  DiffableCollectionViewAdapter+Util.swift
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
struct DiffableCollectionView<Section: Hashable, ID: Hashable, Cell: View>: UIViewRepresentable {

    // MARK: - Private Properties

    let content: [DiffableCollectionViewContent<Section, ID>]
    let properties: DiffableCollectionViewProperties<Section>
    let cellBuilder: (Section, ID) -> Cell

    // MARK: - Init

    init(
        _ content: [DiffableCollectionViewContent<Section, ID>],
        @ViewBuilder cellBuilder: @escaping (Section, ID) -> Cell,
        configure: (inout DiffableCollectionViewProperties<Section>) -> Void = { _ in }
    ) {
        var properties = DiffableCollectionViewProperties<Section>()
        configure(&properties)
        self.properties = properties
        self.content = content
        self.cellBuilder = cellBuilder
    }

    // MARK: - Public Methods

    func makeCoordinator() -> DiffableCollectionViewAdapter<Section, ID, Cell> {
        let layoutProvider = DiffableCollectionViewLayoutProvider(
            content: content,
            properties: properties
        )

        return DiffableCollectionViewAdapter(
            layoutProvider: layoutProvider,
            properties: properties,
            cellBuilder: cellBuilder
        )
    }

    func makeUIView(context: Context) -> UICollectionView {
        context.coordinator.collectionView
    }

    func updateUIView(_ uiView: UICollectionView, context: Context) {
        context.coordinator.performSnapshotUpdates(
            content,
            onWillPerformUpdates: { eventPair in
//                dump(eventPair)
                //properties.stateObserver.onWillPerformUpdates?(eventPair)
            }
        )
    }
}
