//
//  DiffableCollectionViewAdapter+Util.swift
//  DiffableCollectionView
//
//  Created by Cole Roberts on 4/4/25.
//

import Foundation

/// `SnapshotScheduler` determines which dispatch queue is used for applying updates
/// to the collection view's snapshot, ensuring thread-safety and performance optimization.
///
/// - Cases:
///   - `main`: Executes updates on the main queue (`DispatchQueue.main/MainActor`).
///   - `queue(name:qos:)`: Defines a custom queue with a given name and quality of service (`QoS`).
///
/// - Utilities:
///   - `qos(_:)`: Creates a new `SnapshotScheduler` with a random UUID-based queue name and the specified QoS.
///   - `background`: A predefined scheduler running on a background queue with `.background` QoS.
enum DiffableCollectionViewSnapshotScheduler {
    /// The main queue, i.e. `DispatchQueue.main/MainActor`.
    case main

    /// A custom queue with an associated name.
    case queue(name: String, qos: DispatchQoS)

    // MARK: - SnapshotScheduler+Util

    static func qos(_ qos: DispatchQoS) -> Self {
        .queue(name: UUID().uuidString, qos: qos)
    }

    static var background: Self {
        .queue(name: UUID().uuidString, qos: .background)
    }
}
