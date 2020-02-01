import UIKit
import SVProgressHUD

private struct Strings {
    static let placeholder = NSLocalizedString(
        "Enter your favorite TV Shows",
        comment: "Text for searchbar textfield placeholder")

    static let cancel = NSLocalizedString(
        "Cancel", comment: "Button text for alert")
}

class DisplayViewController: UITableViewController {
    var searchController = UISearchController(searchResultsController: nil)

    weak var delegate: DisplayServiceDelegate?

    var service = DisplayService()

    var entries: [DisplayTVShow] = []

    var activateSearch = false

    var searchedText: String?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar()
        service.delegate = self
        self.delegate = service
        tableView.register(DisplayTVShowDetailsTableViewCell.self, forCellReuseIdentifier: DisplayTVShowDetailsTableViewCell.cellReuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = Colors.white.value
        tableView.backgroundView = DisplayNoResultView(isResultFound: true)
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = Colors.white.value
        navigationController?.navigationBar.tintColor = Colors.navBarTintColor.value
        navigationController?.isNavigationBarHidden = false
        if !activateSearch {
            searchController.searchBar.text = searchedText
        }
    }

    func activatedSearch() {
        self.searchController.isActive = true
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }

    private func deactivateSearch() {
        searchController.searchBar.resignFirstResponder()
        view.endEditing(true)
        searchController.isActive = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if activateSearch {
            activatedSearch()
            activateSearch = false
        }
    }

    func searchBar() {
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = Strings.placeholder
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.keyboardType = .asciiCapable
        searchController.hidesNavigationBarDuringPresentation = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DisplayTVShowDetailsTableViewCell.cellReuseIdentifier,
            for: indexPath) as? DisplayTVShowDetailsTableViewCell else {
            return UITableViewCell()
        }

        cell.update(appDetails: entries[indexPath.row])
        cell.backgroundColor = Colors.tableViewBackgroundColor.value
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deactivateSearch()
        tableView.deselectRow(at: indexPath, animated: true)

        let controller = DisplayDetailedTVShowViewController(
            showDetails: entries[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}

extension DisplayViewController: DisplayViewDelegate {
    func showEntries() {
        tableView.backgroundColor = Colors.tableViewBackgroundColor.value
        tableView.backgroundView = UIView()
        tableView.reloadData()
        SVProgressHUD.dismiss()
    }

    func displayError(errorMessage: String) {
        tableView.reloadData()
        let alertController = UIAlertController(
            title: errorMessage, message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(
            title: Strings.cancel, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
        showNoResultFound()
        deactivateSearch()
        SVProgressHUD.dismiss()
    }

    func showNoResultFound() {
        tableView.reloadData()
        let noResultsImageView = DisplayNoResultView(isResultFound: false)
        tableView.backgroundColor = Colors.white.value
        tableView.backgroundView = noResultsImageView
        SVProgressHUD.dismiss()
    }
}

extension DisplayViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchedString = searchBar.text {
            DispatchQueue.main.async {
                SVProgressHUD.show()
            }
            delegate?.getTVShowList(searchString: searchedString.removingWhitespaces)
        }
    }

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if searchBar.searchTextField.isFirstResponder {
            let validString = CharacterSet(
                charactersIn: "!@#$%^&*()_+{}[]|\"<>,.~`/:;?-=\\¥'£•¢")

            if text.rangeOfCharacter(from: validString) != nil {
                return false
            }
        }
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if let searchedString = searchBar.text ,
        searchedString != "" {
            DispatchQueue.main.async {
                SVProgressHUD.show()
            }
            searchedText = searchedString
            delegate?.getTVShowList(searchString: searchedString.removingWhitespaces)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = searchedText
    }
}

extension String {
    var removingWhitespaces: String {
        return self.components(separatedBy: CharacterSet.whitespaces).joined()
    }
}

