//
//  DiffableCollectionViewAdapter+Util.swift
//  DiffableCollectionView
//
//  Created by Cole Roberts on 4/4/25.
//

import Foundation

/// The `Update` enum is designed to efficiently manage changes to a collection of items, such as a list or table view.
/// Each case represents a specific type of update operation, allowing for fine-grained control over how items are modified.
///
/// - Note: Using `reconfigures` instead of `reloads` can help improve performance by avoiding unnecessary content flashes. Internally,
/// this makes use of a `UICollectionView` powered by `NSDiffableDataSource`.
///
/// - Parameters:
///   - _ID: The unique identifier type for the items being updated. Must conform to `Hashable` and `Sendable`.
struct DiffableCollectionViewUpdate<_ID: Hashable & Sendable>: Sendable {
    /// A unique identifier for the event.
    let uuid = UUID()

    /// The type of update.
    let event: Event

    /// Whether the update is animated.
    let animated: Bool

    // MARK: - Init

    /// A convenience initializer for an event that inserts `0` items,
    /// but ensures the correct section layout.
    init(
        animated: Bool = true
    ) {
        self.event = .append(ids: [])
        self.animated = animated
    }

    private init(
        event: Event,
        animated: Bool = true
    ) {
        self.event = event
        self.animated = animated
    }

    // MARK: - Utility

    /// Appends new items to the collection.
    /// - Parameter `_ID`: The identifiers of the items to append.
    static func append(
        ids: [_ID],
        animated: Bool = true
    ) -> Self {
        self.init(event: .append(ids: ids), animated: animated)
    }

    /// Reconfigures existing items without reloading them.
    /// - Note: This is a more efficient way to update content without causing a visible refresh or flash in the UI.
    /// - Parameter `_ID`: The identifiers of the items to reconfigure.
    static func reconfigure(
        ids: [_ID],
        animated: Bool = true
    ) -> Self {
        self.init(event: .reconfigure(ids: ids), animated: animated)
    }

    /// Reloads existing items in the collection.
    /// This operation replaces the current content of the specified items, potentially causing a visible refresh.
    /// - Note: In general, opt to use `reconfigure(identifiers:)`
    /// - Parameter `_ID`: The identifiers of the items to reload
    static func reload(
        ids: [_ID],
        animated: Bool = true
    ) -> Self {
        self.init(event: .reload(ids: ids), animated: animated)
    }

    /// Deletes items from the collection.
    /// - Parameter `_ID`: The identifiers of the items to delete.
    static func delete(
        ids: [_ID],
        animated: Bool = true
    ) -> Self {
        .init(event: .delete(ids: ids), animated: animated)
    }

    /// Replaecs items from the collection.
    /// - Parameter `_ID`: The identifiers of the items used to replace.
    static func replace(
        ids: [_ID],
        animated: Bool = true
    ) -> Self {
        .init(event: .replace(ids: ids), animated: animated)
    }
}

// MARK: - DiffableCollectionViewUpdate+Hashable

extension DiffableCollectionViewUpdate: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

// MARK: - DiffableCollectionViewUpdate+Event

extension DiffableCollectionViewUpdate {
    /// The type of update, i.e. append, reconfigure, etc.
    enum Event {
        /// Appends new items to the collection.
        case append(ids: [_ID])

        /// Reconfigures existing items without reloading them.
        case reconfigure(ids: [_ID])

        /// Reloads existing items in the collection.
        case reload(ids: [_ID])

        /// Deletes items from the collection.
        /// - Parameter `_ID`: The identifiers of the items to delete.
        case delete(ids: [_ID])

        /// Replaces the items from the collection.
        case replace(ids: [_ID])
    }
}
