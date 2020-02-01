/**
 Service calls and controller conforms the protocol
 */
protocol DisplayViewDelegate: class {
    var entries: [DisplayTVShow] { get set }
    func showEntries()
    func displayError(errorMessage: String)
    func showNoResultFound()
}

/**
 Controller calls and Service conforms the protocol
 */
protocol DisplayServiceDelegate: class {
    func getTVShowList(searchString: String)
}

