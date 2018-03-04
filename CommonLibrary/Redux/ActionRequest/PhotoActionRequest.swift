//
//  PhotoActionRequest.swift
//  Caminhante watchOS Extension
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import CoreLocation
import Foundation
import KleinKit

public enum PhotoActionRequest {
    case startSnapshotProcess(newLocation: CLLocation)
}

public enum PhotoError: Error {
    case noPhotosForThisLocation
}

extension PhotoActionRequest: ActionRequest {
    public func execute(getState: @escaping () -> AppState,
                        dispatch: @escaping DispatchFunction,
                        dispatchAsync: @escaping (AnyActionAsync<AppState>) -> Void) {
        switch self {
        case .startSnapshotProcess(let newLocation):
            let store = StoreAccessors(getState: getState, dispatch: dispatch, dispatchAsync: dispatchAsync)
            let photoTask = PhotoActionRequest.fetchPhotoInformation(from: newLocation, with: store)
            dispatch(LocationAction.receivedNewSignificantLocation(location: newLocation,
                                                                   photoTask: photoTask))
        }
    }

    private static func fetchPhotoInformation(from location: CLLocation, with store: StoreAccessors) -> CancelableTask {
        return photoAPI.request(.publicPhotosNearby(location: location.coordinate,
                                                    page: 1,
                                                    pageSize: 1),
                                completion: photoInformationReceived(from: location, with: store))
    }

    private static func photoInformationReceived(from location: CLLocation, with store: StoreAccessors) -> (Result<Data>) -> Void {
        return { result in
            let photoResponseResult: Result<PhotoResponse> = result.flatMap(JsonParser.decode)
            let photoInformationResult: Result<PhotoInformation> = photoResponseResult.flatMap { response in
                if let page = response.responsePage,
                    page.photos.count == 1,
                    var photoInformation = page.photos.first {

                    let task = fetchPhotoBytes(for: photoInformation, with: store)
                    photoInformation.image = .syncing(task: task, oldValue: nil)
                    return .success(photoInformation)
                }

                return .failure(PhotoError.noPhotosForThisLocation)
            }

            store.dispatch(PhotoAction.gotPhotoInformation(photoInformationResult, at: location))
        }
    }

    private static func fetchPhotoBytes(for photoInformation: PhotoInformation, with store: StoreAccessors) -> CancelableTask {
        return photoAPI.request(.publicPhoto(url: photoInformation.watchUrl),
                                completion: photoBytesReceived(photoInformation: photoInformation,
                                                               with: store))
    }

    private static func photoBytesReceived(photoInformation: PhotoInformation, with store: StoreAccessors) -> (Result<Data>) -> Void {
        return { result in
            store.dispatch(PhotoAction.gotPhotoData(result, photoId: photoInformation.id))
        }
    }
}

extension PhotoActionRequest: HasPhotoAPI { }

private struct StoreAccessors {
    let getState: () -> AppState
    let dispatch: DispatchFunction
    let dispatchAsync: (AnyActionAsync<AppState>) -> Void
}
