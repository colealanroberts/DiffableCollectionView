//
//  DiffableCollectionViewAdapter+Util.swift
//  DiffableCollectionView
//
//  Created by Cole Roberts on 4/4/25.
//

import UIKit

final class DiffableCollectionViewSnapshotUpdater<Section: Hashable, ID: Hashable>: DiffableCollectionViewSnapshotUpdating {

    // MARK: - Private Properties

    private var currentUpdate: DiffableCollectionViewUpdate<ID>?
    private let dataSource: DataSource<Section, ID>
    private let updateCache: UpdateCache
    private let updateQueue: DispatchQueue

    // MARK: - Init

    init(
        dataSource: DataSource<Section, ID>,
        snapshotScheduler: DiffableCollectionViewSnapshotScheduler
    ) {
        self.dataSource = dataSource
        self.updateCache = UpdateCache()
        self.updateQueue = snapshotScheduler.queue
    }

    // MARK: - Public Methods

    func performUpdates(
        _ content: [DiffableCollectionViewContent<Section, ID>],
        onWillPerformUpdates: @escaping (DiffableCollectionViewEventPair<ID>) -> Void
    ) {
        var snapshot = dataSource.snapshot()
        var animatingDifferences = true

        for content in content {
            let update = content.update.wrappedValue

            guard updateCache.canApply(update) else {
                continue
            }

            onWillPerformUpdates(
                DiffableCollectionViewEventPair<ID>(
                    previous: currentUpdate?.event,
                    proposed: update.event
                )
            )

            currentUpdate = update
            animatingDifferences = update.animated

            switch update.event {
            case .replace(let ids):
                let identifiersInSection = snapshot.itemIdentifiers(inSection: content.section)
                snapshot.deleteItems(identifiersInSection)
                snapshot.appendItems(ids, toSection: content.section)
            case .append(let ids):
                if !snapshot.sectionIdentifiers.contains(content.section) {
                    snapshot.appendSections([content.section])
                }

                let current = snapshot.itemIdentifiers
                let proposed = ids

                guard current != proposed else {
                    continue
                }

                snapshot.appendItems(proposed, toSection: content.section)
            case .reconfigure(let ids):
                snapshot.reconfigureItems(ids)
            case .reload(let ids):
                snapshot.reloadItems(ids)
            case .delete(let ids):
                snapshot.deleteItems(ids)
            }
        }

        updateQueue.async { [weak dataSource] in
            dataSource?.apply(
                snapshot,
                animatingDifferences: animatingDifferences,
                completion: {}
            )
        }
    }
}

// MARK: - CollectionViewSnapshotUpdater+UpdateCache

private extension DiffableCollectionViewSnapshotUpdater {
    final class UpdateCache {
        /// Tracks the previously applied updates, with a maximum of `N`.
        private var cache = Set<DiffableCollectionViewUpdate<ID>>()

        /// The maximum number of updates to cache.
        /// - Note: The default value is `10`.
        private let maxStoredUpdates: Int

        init(
            maxStoredUpdates: Int = 10
        ) {
            self.maxStoredUpdates = maxStoredUpdates
        }

        func canApply(_ update: DiffableCollectionViewUpdate<ID>) -> Bool {
            guard !cache.contains(update) else {
                return false
            }

            cache.insert(update)

            if cache.count > maxStoredUpdates {
                cache.removeFirst()
            }

            return true
        }
    }
}

// MARK: - DiffableCollectionViewSnapshotScheduler+Util

private extension DiffableCollectionViewSnapshotScheduler {
    var queue: DispatchQueue {
        switch self {
        case .main:
            return .main
        case .queue(let name, let qos):
            return DispatchQueue(label: name, qos: qos)
        }
    }
}
