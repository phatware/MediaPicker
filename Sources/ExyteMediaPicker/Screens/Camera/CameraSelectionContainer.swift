//
//  CameraSelectionContainer.swift
//
//
//  Created by Alisa Mylnikova on 12.07.2022.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

public struct CameraSelectionView: View {

    @EnvironmentObject private var cameraSelectionService: CameraSelectionService
    @State private var index: Int? = 0

    var selectionParamsHolder: SelectionParamsHolder

    public var body: some View {
        GeometryReader { g in
            let size = g.size
            if #available(iOS 17.0, *) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<cameraSelectionService.added.count, id: \.self) { index in
                            if let mediaModel = cameraSelectionService.added[safe: index] {
                                FullscreenCell(viewModel: FullscreenCellViewModel(mediaModel: mediaModel), size: size)
                                    .frame(width: size.width, height: size.height)
                                    .id(index)
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $index)
            } else {
                TabView(selection: $index) {
                    ForEach(cameraSelectionService.added.enumerated().map({ $0 }), id: \.offset) { (index, mediaModel) in
                        FullscreenCell(viewModel: FullscreenCellViewModel(mediaModel: mediaModel), size: size)
                            .tag(index)
                            .frame(maxHeight: .infinity)
                            .padding(.vertical)
                    }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay(alignment: .topTrailing) {
            if selectionParamsHolder.selectionLimit != 1, let index {
                SelectionIndicatorView(
                    index: cameraSelectionService.selectedIndex(fromAddedIndex: index),
                    isFullscreen: true,
                    canSelect: true,
                    selectionParamsHolder: selectionParamsHolder
                )
                .padding(12)
                .contentShape(Rectangle())
                .onTapGesture {
                    cameraSelectionService.onSelect(index: index)
                }
            }
        }
    }
}

struct DefaultCameraSelectionContainer: View {

    @EnvironmentObject private var cameraSelectionService: CameraSelectionService
    @Environment(\.mediaPickerTheme) private var theme

    @ObservedObject var viewModel: MediaPickerViewModel

    @Binding var showingPicker: Bool
    var selectionParamsHolder: SelectionParamsHolder

    private var isPad: Bool {
#if canImport(UIKit)
        UIDevice.current.userInterfaceIdiom == .pad
#else
        false
#endif
    }

    var body: some View {
        CameraSelectionView(selectionParamsHolder: selectionParamsHolder)
            .background(theme.main.cameraSelectionBackground)
            .overlay(alignment: .topLeading) {
                Button("Close") {
                    cameraSelectionService.removeAll()
                    showingPicker = false
                }
                .foregroundColor(theme.main.cameraText)
                .font(.system(size: 18, weight: .semibold))
                .padding(.leading, isPad ? 92 : 24)
                .padding(.trailing, 24)
                .padding(.vertical, 16)
            }
            .overlay(alignment: .bottom) {
                HStack {
                    Button("Retake") {
                        cameraSelectionService.removeAll()
                        viewModel.setPickerMode(.camera)
                    }
                    Spacer()
                    Button("Done") {
                        showingPicker = false
                    }
                    if selectionParamsHolder.selectionLimit != 1 {
                        Button {
                            viewModel.setPickerMode(.camera)
                        } label: {
                            Image(systemName: "plus.app")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                }
                .foregroundColor(theme.main.cameraText)
                .font(.subheadline)
                .padding(.horizontal, 24)
                .padding(.top, 14)
                .padding(.bottom, 24)
            }
    }
}
