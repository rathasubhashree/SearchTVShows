/**
 Service calls and controller conforms the protocol
 */
protocol DisplayViewDelegate: class {
    var tvShows: [DisplayTVShow] { get set }
    func displayTVShowList()
    func displayError(errorMessage: String)
    func showNoResultFound()
}

/**
 Controller calls and Service conforms the protocol
 */
protocol DisplayServiceDelegate: class {
    func getTVShowList(searchString: String)
}
