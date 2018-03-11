import Foundation
import KleinKit

public enum RemoteDeviceActionRequest {
    case handleUpdatedState([String: Any])
    case handleData([String: Any])
    case handleDataWithCompletion([String: Any], completion: ([String: Any]) -> Void)
}

extension RemoteDeviceActionRequest: ActionRequest {
    public func execute(getState: @escaping () -> AppState,
                        dispatch: @escaping DispatchFunction,
                        dispatchAsync: @escaping (AnyActionAsync<AppState>) -> Void) {
        switch self {
        case .handleUpdatedState(let data):
            if case let .success(actionState) = simpleEnumDecode(type: ActivityState?.self,
                                                                 name: ActivityState.className,
                                                                 payload: data) {
                switch actionState {
                case .paused?:
                    dispatch(ActivityAction.activityDidPause)
                case .inProgress?:
                    dispatch(ActivityAction.activityDidStart)
                case .finished?:
                    dispatch(ActivityAction.activityDidFinish)
                case nil:
                    dispatch(ActivityAction.activityDidReset)
                }
            }
        case .handleData: break
        case .handleDataWithCompletion(let data, let completion):
            if case let .success(actionRequest) = simpleEnumDecode(type: ActivityActionRequest.self, payload: data) {
                dispatchAsync(AnyActionAsync(actionRequest))
                completion([:])
                return
            }
            completion(["Error": "Invalid payload"])
        }
    }

    enum DecodeError: Error {
        case invalidPayload
        case invalidJson
        case keyNotFound
    }

    private func simpleEnumDecode<T: Decodable>(type: T.Type, name: String? = nil, payload: [String: Any]) -> Result<T> {
        let typeName = name ?? String(describing: type)
        guard let root = payload[typeName] as? Data else { return .failure(DecodeError.invalidPayload) }
        guard let json = try? JSONDecoder().decode([String: T].self, from: root) else { return .failure(DecodeError.invalidJson) }
        guard let value = json[typeName] else { return .failure(DecodeError.keyNotFound) }
        return .success(value)
    }
}
