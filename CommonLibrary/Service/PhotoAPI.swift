import Foundation
import KleinKit

public protocol PhotoAPI {
    func request(_ endpoint: PhotoServiceEndpoint,
                 completion: @escaping (Result<Data>) -> Void) -> CancelableTask
}
