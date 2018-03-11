import Foundation

/// Possible errors when fetching photos
public enum PhotoResponseErrorCode: Int, Codable {
    /// Too many tags in ALL query
    /// When performing an 'all tags' search, you may not specify more than 20 tags to join together.
    case tooManyTagsInAllQuery = 1

    /// Unknown user
    /// A user_id was passed which did not match a valid flickr user.
    case unknownUser = 2

    /// Parameterless searches have been disabled
    /// To perform a search with no parameters (to get the latest public photos, please use flickr.photos.getRecent instead).
    case parameterlessSearchesHaveBeenDisabled = 3

    /// You don't have permission to view this pool
    /// The logged in user (if any) does not have permission to view the pool for this group.
    case poolNotAuthorized = 4

    /// User deleted
    /// The user id passed did not match a Flickr user.
    case userDeleted = 5

    /// Sorry, the Flickr search API is not currently available.
    /// The Flickr API search databases are temporarily unavailable.
    case apiIsNotAvailable = 10

    /// No valid machine tags
    /// The query styntax for the machine_tags argument did not validate.
    case noValidMachineTags = 11

    /// Exceeded maximum allowable machine tags
    /// The maximum number of machine tags in a single query was exceeded.
    case exceededMaximumAllowableMachineTags = 12

    /// You can only search within your own contacts
    /// The call tried to use the contacts parameter with no user ID or a user ID other than that of the authenticated user.
    case onlyContactsSearchAllowed = 17

    /// Illogical arguments
    /// The request contained contradictory arguments.
    case illogicalArguments = 18

    /// Invalid API Key
    /// The API key passed was not valid or has expired.
    case invalidApiKey = 100

    /// Service currently unavailable
    /// The requested service is temporarily unavailable.
    case serviceCurrentlyUnavailable = 105

    /// Write operation failed
    /// The requested operation failed due to a temporary issue.
    case writeOperationFailed = 106

    /// Format "xxx" not found
    /// The requested response format was not found.
    case invalidRequestFormat = 111

    /// Method "xxx" not found
    /// The requested method was not found.
    case invalidRequestMethod = 112

    /// Invalid SOAP envelope
    /// The SOAP envelope send in the request could not be parsed.
    case invalidSoapEnvelope = 114

    /// Invalid XML-RPC Method Call
    /// The XML-RPC request document could not be parsed.
    case invalidXmlRpcMethodCall = 115

    /// Bad URL found
    /// One or more arguments contained a URL that has been used for abuse on Flickr.
    case badURLFound = 116

    /// Unknown error
    case unknown = 999
}
