//
//  DiffableCollectionViewAdapter+Util.swift
//  DiffableCollectionView
//
//  Created by Cole Roberts on 4/4/25.
//

import SwiftUI

// MARK: - DiffableCollectionViewContent

/// A structure that represents the content of a section within a `CollectionView`.
///
/// `Content` holds a section identifier and a binding to an optional `Update` object,
/// this object can be used to drive UI updates such as insertions, deletions, or modifications
/// of items within the associated section.
///
/// - Parameters:
///   - _Section: The type used to uniquely identify a section.
///   - _ID: The type used to uniquely identify items within the section. Must conform to `Hashable`.
///
/// - Note: Both `_Section` and `_ID` must conform to `Hashable`.
struct DiffableCollectionViewContent<_Section: Hashable, _ID: Hashable> {
    let section: _Section
    let update: Binding<DiffableCollectionViewUpdate<_ID>>

    private init(
        section: _Section,
        update: Binding<DiffableCollectionViewUpdate<_ID>>
    ) {
        self.section = section
        self.update = update
    }
}

// MARK: - CollectionView.Content+Util

extension DiffableCollectionViewContent {
    static func section(
        _ section: _Section,
        update: Binding<DiffableCollectionViewUpdate<_ID>>
    ) -> Self {
        self.init(
            section: section,
            update: update
        )
    }
}
