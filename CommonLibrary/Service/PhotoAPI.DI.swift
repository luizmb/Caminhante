import Foundation
import KleinKit

extension InjectorProtocol {
    public var photoAPI: PhotoAPI { return self.mapper.getSingleton()! }
}

public protocol HasPhotoAPI { }
extension HasPhotoAPI {
    public static var photoAPI: PhotoAPI {
        return injector().photoAPI
    }

    public var photoAPI: PhotoAPI {
        return injector().photoAPI
    }
}
