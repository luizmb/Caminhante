//
//  ActivitySnapshotsRowController.swift
//  Caminhante watchOS Extension
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import CommonLibrary
import WatchKit

final class ActivitySnapshotsRowController: NSObject {
    static let reuseIdentifier = "ActivitySnapshotsRow"

    @IBOutlet var photoImageView: WKInterfaceImage!
    @IBOutlet var placeholderImageView: WKInterfaceImage!

    func update(state: SnapshotPoint?) {
        guard let snapshot = state,
              case let .loaded(.success(photo)) = snapshot.photo,
              let photoData = photo.image.possibleValue()
            else {
            setPlaceholder()
            return
        }

        setPhoto(data: photoData)
    }

    private func setPlaceholder() {
        placeholderImageView.setHidden(false)
        placeholderImageView.setAlpha(1.0)
        photoImageView.setHidden(true)
        photoImageView.setAlpha(0.0)
    }

    private func setPhoto(data: Data) {
        photoImageView.setImageData(data)
        placeholderImageView.setHidden(true)
        placeholderImageView.setAlpha(0.0)
        photoImageView.setHidden(false)
        photoImageView.setAlpha(1.0)
    }
}
