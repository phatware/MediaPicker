//
//  SwiftUIView.swift
//
//
//  Created by Alisa Mylnikova on 21.04.2023.
//

import SwiftUI
import Photos
import AVFoundation
#if canImport(UIKit)
import UIKit
#endif

extension URL {

    func getThumbnailURL() async -> URL? {
        if let thumbnailData = await getThumbnailData() {
            return FileManager.storeToTempDir(data: thumbnailData)
        }
        return nil
    }

    func getThumbnailData() async -> Data? {
        if isImageFile {
#if canImport(UIKit)
            return UIImage.from(url: self)?.generateThumbnail()
#else
            return nil
#endif
        }

        let asset: AVAsset = AVAsset(url: self)
        return asset.generateThumbnail()
    }

    var isImageFile: Bool {
        UTType(filenameExtension: pathExtension)?.conforms(to: .image) ?? false
    }

    var isVideoFile: Bool {
        UTType(filenameExtension: pathExtension)?.conforms(to: .audiovisualContent) ?? false
    }
}
