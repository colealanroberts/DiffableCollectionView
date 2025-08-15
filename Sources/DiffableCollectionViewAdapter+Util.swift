//
//  DiffableCollectionViewAdapter+Util.swift
//  DiffableCollectionView
//
//  Created by Cole Roberts on 4/4/25.
//

import UIKit
import SwiftUI

extension DiffableCollectionViewAdapter {

    // MARK: - Private Factory Methods

    static func makeCollectionView(
        using layout: UICollectionViewCompositionalLayout
    ) -> UICollectionView {
        UICollectionView(frame: .zero, collectionViewLayout: layout)
    }

    static func makeDataSource(
        for collectionView: UICollectionView,
        using cellBuilder: @escaping (Section, ID) -> Cell
    ) -> DataSource<Section, ID> {
        let registration = CellRegistration<UICollectionViewCell, ID> { cell, indexPath, item in
            guard let dataSource = collectionView.dataSource as? DataSource<Section, ID> else {
                assertionFailure("Expected `collectionView.dataSource` to be of type `DataSource`, got \(type(of: collectionView.dataSource)).")
                return
            }

            guard let section = dataSource.sectionIdentifier(for: indexPath.section) else {
                assertionFailure("Expected `sectionIdentifier for \(indexPath.section).`")
                return
            }

            cell.contentConfiguration = UIHostingConfiguration {
                cellBuilder(section, item)
            }
            .margins(.all, 0)
        }

        return DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: item
            )
        }
    }
}
