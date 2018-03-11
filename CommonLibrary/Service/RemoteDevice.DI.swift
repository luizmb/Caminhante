import Foundation
import KleinKit

extension InjectorProtocol {
    public var remoteDevice: RemoteDevice { return self.mapper.getSingleton()! }
}

public protocol HasRemoteDevice { }
extension HasRemoteDevice {
    public static var remoteDevice: RemoteDevice {
        return injector().remoteDevice
    }

    public var remoteDevice: RemoteDevice {
        return injector().remoteDevice
    }
}
