//
//  DiffableCollectionViewAdapter+Util.swift
//  DiffableCollectionView
//
//  Created by Cole Roberts on 4/4/25.
//

import Foundation

struct DiffableCollectionViewProperties<Section: Hashable> {

    // MARK: - Public Properties

    /// Enables configuration of the backing compositional layout through closure-backed syntax.
    var layoutBuilder: (Section) -> DiffableCollectionViewLayout

    /// Provides configuration options when determining which queue performs the snapshot updates.
    var snapshotScheduler: DiffableCollectionViewSnapshotScheduler

    /// Yields scroll information through a series of closure-backed properties.
    var stateObserver: DiffableCollectionViewStateObserver<Section>

    // MARK: - Init

    init(
        layoutBuilder: @escaping (Section) -> DiffableCollectionViewLayout = { _ in .list() },
        snapshotScheduler: DiffableCollectionViewSnapshotScheduler = .main,
        stateObserver: DiffableCollectionViewStateObserver<Section> = DiffableCollectionViewStateObserver()
    ) {
        self.layoutBuilder = layoutBuilder
        self.snapshotScheduler = snapshotScheduler
        self.stateObserver = stateObserver
    }
}
