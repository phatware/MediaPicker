//
//  Untitled.swift
//  ExyteMediaPicker
//
//  Created by Alisa Mylnikova on 25.03.2025.
//

import SwiftUI

/// Fixed-width grid columns that exactly fill `containerWidth`.
///
/// At least 3 columns (an iPhone in portrait is unchanged); wider containers get
/// more columns so cells stay about `targetCellWidth` across instead of growing
/// with the window. The width must be the grid's own container, not the screen:
/// an iPad window or Split View is narrower than the screen.
func calculateColumnWidth(containerWidth: CGFloat, spacing: CGFloat) -> (CGFloat, [GridItem]) {
    let targetCellWidth: CGFloat = 160
    let columnCount = max(3, Int((containerWidth + spacing) / (targetCellWidth + spacing)))
    let noSpaces = containerWidth - spacing * CGFloat(columnCount - 1)
    let columnWidth = noSpaces / CGFloat(columnCount)
    let columns = Array(repeating: GridItem(.fixed(columnWidth), spacing: spacing, alignment: .top), count: columnCount)
    return (columnWidth, columns)
}

extension View {
    /// Keeps `width` equal to this view's laid-out width.
    func widthReader(_ width: Binding<CGFloat>) -> some View {
        background {
            GeometryReader { proxy in
                Color.clear
                    .onAppear { width.wrappedValue = proxy.size.width }
                    .onChange(of: proxy.size.width) { _, newWidth in
                        width.wrappedValue = newWidth
                    }
            }
        }
    }
}
