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
            var photoInformationResult: Result<PhotoInformation> = result.flatMap(JsonParser.decode)

            if case var .success(photoInformation) = photoInformationResult {
                let task = fetchPhotoBytes(for: photoInformation, with: store)
                photoInformation.image = .syncing(task: task, oldValue: nil)
                photoInformationResult = .success(photoInformation)
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
