//
//  Grid.swift
//  CS193p
//
//  Created by lym on 2021/4/13.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView

    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }

    var body: some View {
        GeometryReader { geometry in
            body(for: GridLayout(itemCount: items.count, nearAspectRatio: 1, in: geometry.size))
        }
    }

    private func body(for layout: GridLayout) -> some View {
        ForEach(items) { item in
            body(for: item, in: layout)
        }
    }

    private func body(for item: Item, in layout: GridLayout) -> some View {
        return Group {
            if let idx = items.firstIndex(where: { $0.id == item.id }) {
                viewForItem(item)
                    .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                    .position(layout.location(ofItemAt: idx))
            }
        }
    }
}
