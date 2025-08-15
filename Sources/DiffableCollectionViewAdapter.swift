//
//  DiffableCollectionViewAdapter+Util.swift
//  DiffableCollectionView
//
//  Created by Cole Roberts on 4/4/25.
//

import SwiftUI

typealias Snapshot = NSDiffableDataSourceSnapshot
typealias DataSource = UICollectionViewDiffableDataSource
typealias CellRegistration = UICollectionView.CellRegistration

final class DiffableCollectionViewAdapter<Section: Hashable, ID: Hashable, Cell: View>: NSObject, UICollectionViewDelegate {

    // MARK: - Public Properties

    let collectionView: UICollectionView

    // MARK: - Private Properties

    private let cellBuilder: (Section, ID) -> Cell
    private let dataSource: DataSource<Section, ID>
    private let properties: DiffableCollectionViewProperties<Section>
    private let layoutProvider: DiffableCollectionViewLayoutProvider<Section, ID>
    private let snapshotUpdater: DiffableCollectionViewSnapshotUpdater<Section, ID>

    // MARK: - Init

    init(
        layoutProvider: DiffableCollectionViewLayoutProvider<Section, ID>,
        properties: DiffableCollectionViewProperties<Section>,
        cellBuilder: @escaping (Section, ID) -> Cell
    ) {
        self.properties = properties
        self.cellBuilder = cellBuilder
        self.layoutProvider = layoutProvider

        self.collectionView = Self.makeCollectionView(
            using: layoutProvider.makeLayout()
        )

        self.dataSource = Self.makeDataSource(
            for: collectionView,
            using: cellBuilder
        )

        self.snapshotUpdater = DiffableCollectionViewSnapshotUpdater(
            dataSource: dataSource,
            snapshotScheduler: properties.snapshotScheduler
        )

        super.init()
        collectionView.delegate = self
    }

    // MARK: - Snapshot Updates

    func performSnapshotUpdates(
        _ content: [DiffableCollectionViewContent<Section, ID>],
        onWillPerformUpdates: @escaping (DiffableCollectionViewEventPair<ID>) -> Void
    ) {
        snapshotUpdater.performUpdates(
            content,
            onWillPerformUpdates: onWillPerformUpdates
        )
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        properties.stateObserver.onDidScroll?()
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        properties.stateObserver.onDidSelectIndexPath?(indexPath)
    }
}
