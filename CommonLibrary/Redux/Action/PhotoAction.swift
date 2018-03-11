import CoreLocation
import KleinKit

public enum PhotoAction: Action {
    case gotPhotoInformation(Result<PhotoInformation>, id: UUID)
    case gotPhotoData(Result<Data>, photoId: String)
}
