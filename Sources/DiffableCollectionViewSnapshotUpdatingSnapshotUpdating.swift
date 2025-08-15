//
//  DiffableCollectionViewAdapter+Util.swift
//  DiffableCollectionView
//
//  Created by Cole Roberts on 4/4/25.
//

import Foundation

/// A protocol that defines a type capable of performing diffable data source snapshot updates.
///
/// Types conforming to `SnapshotUpdating` should be able to consume an array of `Content`.
protocol DiffableCollectionViewSnapshotUpdating {
    associatedtype Section: Hashable
    associatedtype ID: Hashable

    /// Performs updates based on the provided content array.
    ///
    /// - Parameter content: An array of `CollectionView.Content` representing updates for sections.
    func performUpdates(
        _ content: [DiffableCollectionViewContent<Section, ID>],
        onWillPerformUpdates: @escaping (DiffableCollectionViewEventPair<ID>) -> Void
    )
}
