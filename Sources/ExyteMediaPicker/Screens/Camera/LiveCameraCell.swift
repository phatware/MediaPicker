//
//  Created by Alex.M on 06.06.2022.
//

import SwiftUI

struct LiveCameraCell: View {

    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Color.black.opacity(0.3)
                Image(systemName: "camera")
                    .foregroundColor(.white)
            }
        }
    }
}
