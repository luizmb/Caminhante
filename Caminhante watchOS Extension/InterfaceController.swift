//
//  InterfaceController.swift
//  Caminhante watchOS Extension
//
//  Created by Luiz Rodrigo Martins Barbosa on 02.03.18.
//

import Foundation
import KleinKit
import WatchKit

class InterfaceController: WKInterfaceController {

    @IBOutlet var label: WKInterfaceLabel!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        // Configure interface objects here.
        label.setText("a".leftPadding(toLength: 4, withPad: "0"))
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
