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
    @IBOutlet var photoTitleLabel: WKInterfaceLabel!
    @IBOutlet var photoTitleLabelBackground: WKInterfaceGroup!

    private var currentState: SnapshotPoint? {
        didSet {
            guard currentState != oldValue else { return }

            guard let snapshot = currentState,
                case let .loaded(.success(photo)) = snapshot.photo else {
                setPlaceholder(title: "")
                return
            }

            guard let photoInformation = photo.image.possibleValue() else {
                setPlaceholder(title: photo.title)
                return
            }

            setPhoto(data: photoInformation, title: photo.title)
        }
    }

    func update(state: SnapshotPoint?) {
        currentState = state
    }

    private func setPlaceholder(title: String) {
        placeholderImageView.setHidden(false)
        placeholderImageView.setAlpha(1.0)
        photoImageView.setHidden(true)
        photoImageView.setAlpha(0.0)
        photoTitleLabel.setText(title)
        photoTitleLabelBackground.setHidden(title == "")
    }

    private func setPhoto(data: Data, title: String) {
        photoImageView.setImageData(data)
        placeholderImageView.setHidden(true)
        placeholderImageView.setAlpha(0.0)
        photoImageView.setHidden(false)
        photoImageView.setAlpha(1.0)
        photoTitleLabel.setText(title)
        photoTitleLabelBackground.setHidden(title == "")
    }
}
