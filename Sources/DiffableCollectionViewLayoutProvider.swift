//
//  DiffableCollectionViewAdapter+Util.swift
//  DiffableCollectionView
//
//  Created by Cole Roberts on 4/4/25.
//

import UIKit

/// A layout provider that builds compositional layouts based on section configuration.
final class DiffableCollectionViewLayoutProvider<Section, ID> where Section: Hashable, ID: Hashable {

    // MARK: - Private  Properties

    private let content: [DiffableCollectionViewContent<Section, ID>]
    private let properties: DiffableCollectionViewProperties<Section>

    // MARK: - Init

    init(
        content: [DiffableCollectionViewContent<Section, ID>],
        properties: DiffableCollectionViewProperties<Section>
    ) {
        self.content = content
        self.properties = properties
    }

    func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self else { fatalError() }

            let layout = properties.layoutBuilder(content[sectionIndex].section)
            let section: NSCollectionLayoutSection
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)

            var horizontalSize: NSCollectionLayoutDimension {
                switch layout.horizontalSize {
                case .absolute(let size):
                        .absolute(size)
                case .fraction(let fraction):
                        .fractionalWidth(fraction)
                case .unconstrained:
                        .fractionalWidth(1.0)
                case .estimated(let size):
                        .estimated(size)
                }
            }

            var verticalSize: NSCollectionLayoutDimension {
                switch layout.verticalSize {
                case .absolute(let size):
                        .absolute(size)
                case .fraction(let fraction):
                        .fractionalHeight(fraction)
                case .unconstrained:
                        .fractionalHeight(1.0)
                case .estimated(let size):
                        .estimated(size)
                }
            }

            let item: NSCollectionLayoutItem
            let groupSize: NSCollectionLayoutSize
            let group: NSCollectionLayoutGroup

            switch layout.composition {
            case .grid(let columns):
                let fraction: CGFloat = 1 / CGFloat(columns)

                item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(fraction),
                        heightDimension: verticalSize
                    )
                )

                item.contentInsets = layout.itemInsets

                groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(fraction)
                )

                group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )

                section = NSCollectionLayoutSection(group: group)
            case .horizontal(let scrollingBehavior):
                item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: horizontalSize,
                        heightDimension: verticalSize
                    )
                )

                item.contentInsets = layout.itemInsets
                groupSize = NSCollectionLayoutSize(
                    widthDimension: horizontalSize,
                    heightDimension: verticalSize
                )

                group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )

                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = scrollingBehavior
            case .list:
                configuration.showsSeparators = false

                section = NSCollectionLayoutSection.list(
                    using: configuration,
                    layoutEnvironment: layoutEnvironment
                )
            case .vertical:
                item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: horizontalSize,
                        heightDimension: verticalSize
                    )
                )

                item.contentInsets = layout.itemInsets

                groupSize = NSCollectionLayoutSize(
                    widthDimension: horizontalSize,
                    heightDimension: verticalSize
                )

                group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitems: [item]
                )

                section = NSCollectionLayoutSection(group: group)
            case .section(let section):
                return section
            }

            section.contentInsets = layout.sectionInsets
            section.interGroupSpacing = layout.interGroupSpacing

            return section
        }
    }
}
