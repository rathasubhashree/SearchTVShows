/**
 NetworkResponse contains different network response strings
 */
enum NetworkResponse: String {
    case success
    case authenticationError = "Authentication failed"
    case badRequest = "Internal Server Error"
    case tooManyRequest = "Too many request, exceeded limit"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}
