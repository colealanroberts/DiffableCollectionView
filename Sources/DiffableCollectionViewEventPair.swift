//
//  DiffableCollectionViewEventPair.swift
//  DiffableCollectionView
//
//  Created by Cole Roberts on 4/4/25.
//

import Foundation

public struct DiffableCollectionViewEventPair<ID: Hashable> {
    /// The current or previous state, i.e. the state to transition from.
    let previous: DiffableCollectionViewUpdate<ID>.Event?

    /// The proposed state change, i.e. the next state to transition to.
    let proposed: DiffableCollectionViewUpdate<ID>.Event

    init(
        previous: DiffableCollectionViewUpdate<ID>.Event?,
        proposed: DiffableCollectionViewUpdate<ID>.Event
    ) {
        self.previous = previous
        self.proposed = proposed
    }
}
