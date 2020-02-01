import Alamofire

class DisplayService {
    weak var delegate: DisplayViewDelegate?
}

extension DisplayService: DisplayServiceDelegate {
    func getTVShowList(searchString: String) {
        let url = Constants.tvShowsUrlString + searchString
        HTTPHandler.handle(urlString: url) { (response) in
            switch response {
            case .success(let result):
                do {
                    let resultData = try JSONDecoder().decode(
                        [DisplayTVShow].self, from: result)
                    self.delegate?.entries = resultData

                    if resultData.isEmpty {
                        self.delegate?.showNoResultFound()
                    } else {
                        self.delegate?.showEntries()
                    }
                } catch {
                    self.delegate?.displayError(
                        errorMessage: NetworkResponse.badRequest.rawValue)
                }
            case .failure(let error):
                self.delegate?.displayError(errorMessage: error)
            }
        }
    }
}
