//
//  Created by Alex.M on 08.06.2022.
//

import Foundation
import SwiftUI
import Photos

final class SelectionService: ObservableObject {

    var mediaSelectionLimit: Int?
    var onChange: MediaPickerCompletionClosure? = nil

    @Published private(set) var selected: [AssetMediaModel] = []

    var canSendSelected: Bool {
        !selected.isEmpty
    }

    var fitsSelectionLimit: Bool {
        if let selectionLimit = mediaSelectionLimit {
            return selected.count < selectionLimit
        }
        return true
    }

    func canSelect(assetMediaModel: AssetMediaModel) -> Bool {
        // When limit is 1, always allow selection (we support replacement)
        if mediaSelectionLimit == 1 {
            return true
        }
        return fitsSelectionLimit || selected.contains(assetMediaModel)
    }

    func onSelect(assetMediaModel: AssetMediaModel) {
        if let index = selected.firstIndex(of: assetMediaModel) {
            selected.remove(at: index)
        } else {
            // When limit is 1, replace the existing selection instead of blocking
            if mediaSelectionLimit == 1 && !selected.isEmpty {
                selected.removeAll()
                selected.append(assetMediaModel)
            } else if fitsSelectionLimit {
                selected.append(assetMediaModel)
            }
        }
        onChange?(mapToMedia())
    }

    func index(of assetMediaModel: AssetMediaModel) -> Int? {
        selected.firstIndex(of: assetMediaModel)
    }

    func mapToMedia() -> [Media] {
        selected
            .compactMap {
                guard $0.mediaType != nil else {
                    return nil
                }
                return Media(source: $0)
            }
    }

    func removeAll() {
        selected.removeAll()
        onChange?([])
    }

    func updateSelection(with models: [AssetMediaModel]) {
        selected = selected.filter {
            models.contains($0)
        }
    }
}
