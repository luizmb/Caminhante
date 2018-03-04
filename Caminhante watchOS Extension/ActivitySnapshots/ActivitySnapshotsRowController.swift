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
}
