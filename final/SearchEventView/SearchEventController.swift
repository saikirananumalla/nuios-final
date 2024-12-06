import UIKit
import FirebaseFirestore

class SearchEventController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private var allEvents: [Event] = [] // All events from Firestore
    private var filteredEvents: [Event] = [] // Filtered events based on search text
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAllEvents()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        // Setup Search Bar
        searchBar.delegate = self
        searchBar.placeholder = "Search events..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        // Setup TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - Fetch Events
    private func fetchAllEvents() {
        let db = Firestore.firestore()
        db.collection("events").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching events: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else { return }
            
            self.allEvents = documents.compactMap { document in
                try? document.data(as: Event.self)
            }
            
            // Initially show all events
            self.filteredEvents = self.allEvents
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredEvents = allEvents
        } else {
            filteredEvents = allEvents.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        let event = filteredEvents[indexPath.row]
        cell.textLabel?.text = event.name
        return cell
    }
    
    // MARK: - TableView Delegate (Optional)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = filteredEvents[indexPath.row]
        print("Selected Event: \(selectedEvent.name)")
        // Perform navigation or show details for the selected event
    }
}


