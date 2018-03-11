import Foundation

extension KeyedDecodingContainer {
    func decodeIntOrString(forKey key: K) throws -> Int {
        if let value = try? self.decode(Int.self, forKey: key) {
            return value
        }

        let string = try self.decode(String.self, forKey: key)
        guard let int = Int(string) else {
            throw DecodingError.typeMismatch(Int.self,
                                             DecodingError.Context(codingPath: [key],
                                                                   debugDescription: "Can't convert \(string) to Int"))
        }

        return int
    }

    func decodeBoolOrInt(forKey key: K) throws -> Bool {
        if let value = try? self.decode(Bool.self, forKey: key) {
            return value
        }

        let int = try self.decode(Int.self, forKey: key)
        switch int {
        case 0: return false
        case 1: return true
        default: throw DecodingError.typeMismatch(Bool.self,
                                                  DecodingError.Context(codingPath: [key],
                                                                        debugDescription: "Can't convert \(int) to Bool"))
        }
    }
}
