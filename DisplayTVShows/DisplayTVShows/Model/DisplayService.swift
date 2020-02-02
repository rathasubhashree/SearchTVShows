import Foundation
/**
 *  Display Service gets the TV shows details from TV Maze REST API.
 */
class DisplayService {
    weak var delegate: DisplayViewDelegate?
}

extension DisplayService: DisplayServiceDelegate {
    /**
     Fetches all tv shows details matching user search criteria.
     */
    func getTVShowList(searchString: String) {

        // preparing url based on the search string
        let url = Constants.tvShowsUrlString + searchString

        // calling HTTPHandler to perform HTTP GET request
        HTTPHandler.handle(urlString: url) { (response) in
            switch response {
            case .success(let result):
                do {
                    let resultData = try JSONDecoder().decode(
                        [DisplayTVShow].self, from: result)
                    self.delegate?.tvShows = resultData

                    if resultData.isEmpty {
                        self.delegate?.showNoResultFound()
                    } else {
                        self.delegate?.displayTVShowList()
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
