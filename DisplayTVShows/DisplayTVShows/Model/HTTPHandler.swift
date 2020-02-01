import Alamofire

struct HTTPHandler {
    typealias handler = (Result<Data, String>) -> Void

    static func handle(
    urlString: String,
    completionHandler: @escaping handler) {
        Alamofire.request(urlString).responseJSON { (response) in
            switch response.result {
            case .success:
                if let responseData = response.data {
                    completionHandler(.success(responseData))
                } else {
                    completionHandler(.failure(
                        NetworkResponse.noData.rawValue))
                }
            case .failure(let error):
                guard let statusCode = response.response?.statusCode else {
                    completionHandler(.failure(error.localizedDescription))
                    return
                }
                let errorMessage = handleErrorMessage(statusCode: statusCode)
                completionHandler(.failure(errorMessage))
            }
        }
    }

    static func handleErrorMessage(statusCode: Int) -> String {
        switch statusCode {
        case 400...499:
            return NetworkResponse.authenticationError.rawValue
        case 500...599:
            return NetworkResponse.badRequest.rawValue
        case 600:
            return NetworkResponse.outdated.rawValue
        default:
            return NetworkResponse.failed.rawValue
        }
    }
}

enum Result<Value, String> {
    case success(Value)
    case failure(String)
}

/**
NetworkResponse contains different network response strings
 */
enum NetworkResponse: String {
    case success
    case authenticationError = "Authentication failed"
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

