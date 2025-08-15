//
//  DiffableCollectionViewAdapter+Util.swift
//  DiffableCollectionView
//
//  Created by Cole Roberts on 4/4/25.
//

import Foundation

/// A state observer for monitoring user interactions within a collection view.
/// `StateObserver` provides closures to track scrolling events and item selections,
/// allowing external components to respond accordingly.
struct DiffableCollectionViewStateObserver<ID: Hashable> {
    /// Informs the caller that the collection view was scrolled.
    var onDidScroll: (() -> Void)?

    /// Informs the caller which `IndexPath` was selected.
    var onDidSelectIndexPath: ((IndexPath) -> Void)?

    /// Informs the caller that the follow updates are queued for application.
    /// - Note: This closure provides a tuple containing
    /// `current` and `proposed` results.
    var onWillPerformUpdates: ((DiffableCollectionViewEventPair<ID>) -> Void)?

    init(
        onDidScroll: (() -> Void)? = nil,
        onDidSelectIndexPath: ((IndexPath) -> Void)? = nil,
        onWillPerformUpdates: ((DiffableCollectionViewEventPair<ID>) -> Void)? = nil
    ) {
        self.onDidScroll = onDidScroll
        self.onDidSelectIndexPath = onDidSelectIndexPath
        self.onWillPerformUpdates = onWillPerformUpdates
    }
}
