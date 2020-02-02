import Foundation

/**
 HTTPHandler is a generic helper utitlity to hanlde http request.
 */
struct HTTPHandler {
    private static let requestTimeOut = 10.0
    private static let successStatusCode = 200

    typealias handler = (Result<Data, String>) -> Void

    static func handle(
        urlString: String,
        completionHandler: @escaping handler) {
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(NetworkResponse.outdated.rawValue))
            return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.GET.rawValue
        urlRequest.timeoutInterval = HTTPHandler.requestTimeOut
        let dataTask = URLSession(
            configuration: .default).dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    completionHandler(.failure(error.localizedDescription))
                } else {
                    if let response = response as? HTTPURLResponse {
                        let result = self.handleNetworkResponse(response)
                        switch result {
                        case .success:
                            guard let data = data else {
                                completionHandler(.failure(
                                    NetworkResponse.noData.rawValue))
                                return
                            }
                            completionHandler(.success(data))
                        case .failure(let networkFailure):
                            completionHandler(.failure(networkFailure))
                        }
                    }
                }
        }
        dataTask.resume()
    }

    static private func handleNetworkResponse(
        _ response: HTTPURLResponse) -> Result<String, String> {
        switch response.statusCode {
        case 200:
            return .success("")
        case 400...410:
            return .failure(NetworkResponse.authenticationError.rawValue)
        case 429:
            return .failure(NetworkResponse.tooManyRequest.rawValue)
        case 500:
            return .failure(NetworkResponse.badRequest.rawValue)
        case 600:
            return .failure(NetworkResponse.outdated.rawValue)
        default:
            return .failure(NetworkResponse.failed.rawValue)
        }
    }
}

enum Result<Value, String> {
    case success(Value)
    case failure(String)
}
