import UIKit
import FirebaseAuth
import FirebaseFirestore
import MapKit

class HomeViewController: UIViewController {
    
    let homePage = HomeScreen()
    
    let mapView = MKMapView()
    
    let tableView = UITableView()
    
    var currentUser:FirebaseAuth.User?
    
    let locationManager = CLLocationManager()
    
    let db = Firestore.firestore()
    
    var activeEvents = [Event]()
    
    let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = homePage
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        homePage.currentEventsButton.addTarget(self, action: #selector(onCurrentEventsButtonTapped), for: .touchUpInside)
        homePage.rsvpButton.addTarget(self, action: #selector(onRsvpButtonTapped), for: .touchUpInside)
        homePage.createdByYouButton.addTarget(self, action: #selector(onCreatedByYouButtonTapped), for: .touchUpInside)
        homePage.searchButton.addTarget(self, action: #selector(onSearchButtonTapped), for: .touchUpInside)
        
        homePage.iconButton1.addTarget(self, action: #selector(onHomeButtonTapped), for: .touchUpInside)
        homePage.iconButton2.addTarget(self, action: #selector(onAddButtonTapped), for: .touchUpInside)
        homePage.iconButton3.addTarget(self, action: #selector(onMapButtonTapped), for: .touchUpInside)
        homePage.iconButton4.addTarget(self, action: #selector(onUserInfoButtonTapped), for: .touchUpInside)
        
        
        notificationCenter.addObserver(
            self, selector: #selector(notificationReceivedForAddEvent(notification:)),
            name: .addFromAddEventScreen,
            object: nil)
        
        notificationCenter.addObserver(
            self, selector: #selector(notificationReceivedForEditEvent(notification:)),
            name: .editFromEditScreen,
            object: nil)
        
        notificationCenter.addObserver(
            self, selector: #selector(notificationReceivedForDeleteEvent(notification:)),
            name: .deleteFromDeleteScreen,
            object: nil)
        
        populateEvents()

    }
    
    @objc func onButtonCurrentLocationTapped(){
        self.mapView.centerToLocation(location: locationManager.location!)
    }
    
    @objc func onCurrentEventsButtonTapped() {
        
        fetchEvents { result in
            switch result {
            case .success(let events):
                print("Fetched Events:")
            case .failure(let error):
                print("Error fetching events: \(error)")
            }
        }
        
        self.tableView.register(TableViewEventCell.self, forCellReuseIdentifier: "events")
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        homePage.thirdSection = tableView
    
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        homePage.setupView()
        homePage.setupConstraints()
        
    }
    
    @objc func onRsvpButtonTapped() {
        
        // Figure out a way to retrieve events under a user through firestore calls.
        fetchFilteredEvents(forUserId: "user1", filter: "random") { result in
            switch result {
            case .success(let events):
                print("Fetched rsvp Events:")
            case .failure(let error):
                print("Error fetching events: \(error)")
            }
        }
        
        self.tableView.register(TableViewEventCell.self, forCellReuseIdentifier: "events")
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        homePage.thirdSection = tableView
    
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        homePage.setupView()
        homePage.setupConstraints()
        
    }
    
    @objc func onCreatedByYouButtonTapped() {
        
        // Figure out a way to retrieve events under a user through firestore calls.
        fetchFilteredEvents(forUserId: "user1", filter: "createdByYou") { result in
            switch result {
            case .success(let events):
                print("Fetched created by you Events:")
            case .failure(let error):
                print("Error fetching events: \(error)")
            }
        }
        
        self.tableView.register(TableViewEventCell.self, forCellReuseIdentifier: "events")
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        homePage.thirdSection = tableView
    
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        homePage.setupView()
        homePage.setupConstraints()
        
    }
    
    @objc func onHomeButtonTapped() {
        
        fetchEvents { result in
            switch result {
            case .success(let events):
                print("Fetched Events:")
            case .failure(let error):
                print("Error fetching events: \(error)")
            }
        }
        
        self.tableView.register(TableViewEventCell.self, forCellReuseIdentifier: "events")
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        homePage.thirdSection = tableView
    
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        homePage.setupView()
        homePage.setupConstraints()
        
    }
    
    @objc func onAddButtonTapped() {
        let createEventVC = CreateEventViewController()
        self.navigationController?.pushViewController(createEventVC, animated: true)
    }
    
    @objc func onMapButtonTapped() {
        
        print("In the map view")
        
        homePage.thirdSection.removeFromSuperview()
        //self.mapView.buttonCurrentLocation.addTarget(self, action: #selector(onButtonCurrentLocationTapped), for: .touchUpInside)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 10
        setupLocationManager()
        onButtonCurrentLocationTapped()
        annotatePlaces()
        self.mapView.delegate = self
        self.homePage.thirdSection = self.mapView
        homePage.setupView()
        homePage.setupConstraints()
        
    }
    
    func annotatePlaces() {
        
        self.mapView.removeAnnotations(self.mapView.annotations)

        for event in activeEvents {
            var tempLocation = Place(
                title: event.name,
                coordinate: CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude),
                info: event.description
            )
            self.mapView.addAnnotation(tempLocation)
        }
        
    }
    
    @objc func onUserInfoButtonTapped() {
        
        let userInfoScreen = UserInfoViewController()
        userInfoScreen.currentUser = self.currentUser
        navigationController?.pushViewController(userInfoScreen, animated: true)
        
    }
    
    @objc func onSearchButtonTapped() {
        
        let searchScreen = SearchEventController()
        navigationController?.pushViewController(searchScreen, animated: true)
        
    }
    
    @objc func notificationReceivedForAddEvent(notification: Notification){
        populateEvents()
    }
    
    @objc func notificationReceivedForEditEvent(notification: Notification){
    }
    
    @objc func notificationReceivedForDeleteEvent(notification: Notification){
    }
    
    func populateEvents() {
        
        fetchEvents { result in
            switch result {
            case .success(let events):
                print("Fetched Events:")
            case .failure(let error):
                print("Error fetching events: \(error)")
            }
        }
        
        self.tableView.register(TableViewEventCell.self, forCellReuseIdentifier: "events")
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        homePage.thirdSection = tableView
    
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        homePage.setupView()
        homePage.setupConstraints()
        
    }
    
    func fetchEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        let db = Firestore.firestore()
        let eventsRef = db.collection("events")
        
        self.activeEvents.removeAll()
        
        eventsRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.success([])) // Return empty array if no documents found
                return
            }
            
            // Convert documents to Event objects
            var events: [Event] = []
            //self.activeEvents.removeAll()
            for document in documents {
                do {
                    let event = try document.data(as: Event.self) // Decodes using Codable
                    events.append(event)
                    print("Adding the event")
                    self.activeEvents.append(event)
                } catch {
                    print("Error decoding event: \(error)")
                    completion(.failure(error))
                    return
                }
            }
            
            self.tableView.reloadData()
            
            completion(.success(events))
        }
    }
    
    func fetchFilteredEvents(forUserId userId: String, filter: String, completion: @escaping (Result<[Event], Error>) -> Void) {
        let db = Firestore.firestore()
        let usersRef = db.collection("users").document(userId)
        
        self.activeEvents.removeAll()
        
        usersRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                print("no \(filter) data exists for the user")
                completion(.success([])) // No data for user
                return
            }
            
            do {
                // Decode the user data
                let user = try document.data(as: User.self)
                
                // Fetch events.
                var eventReferences = user.rsvpByYou
                if (filter == "createdByYou") {
                    eventReferences = user.createdByYou
                }
                var events: [Event] = []
                let dispatchGroup = DispatchGroup()
                
                for eventRef in eventReferences {
                    dispatchGroup.enter()
                    eventRef.getDocument { (eventDoc, error) in
                        if let error = error {
                            print("Error fetching event: \(error)")
                            dispatchGroup.leave()
                            return
                        }
                        
                        guard let eventDoc = eventDoc, eventDoc.exists else {
                            dispatchGroup.leave()
                            return
                        }
                        
                        do {
                            let event = try eventDoc.data(as: Event.self)
                            events.append(event)
                            print(event.description)
                            self.activeEvents.append(event)
                            self.tableView.reloadData()
                        } catch {
                            print("Error decoding event: \(error)")
                        }
                        dispatchGroup.leave()
                    }
                }
                
                self.tableView.reloadData()
                
                dispatchGroup.notify(queue: .main) {
                    completion(.success(events))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func createSampleData() {
            // Create sample users
            let usersRef = db.collection("users")
            let user1 = [
                "name": "Alice",
                "emailId": "alice@example.com",
                "profilePicture": "bucket/profile_pictures/alice.jpg",
                "createdByYou": [], // Placeholder, events will be added later
                "rsvpByYou": [] // Placeholder, RSVP events will be added later
            ] as [String: Any]
            let user2 = [
                "name": "Bob",
                "emailId": "bob@example.com",
                "profilePicture": "bucket/profile_pictures/bob.jpg",
                "createdByYou": [],
                "rsvpByYou": []
            ] as [String: Any]
            
            usersRef.document("user1").setData(user1)
            usersRef.document("user2").setData(user2)
     
            // Create sample Event Tags
            let eventTagsRef = db.collection("eventTags")
            let tag1 = ["name": "Music"]
            let tag2 = ["name": "Sports"]
            let tag3 = ["name": "Networking"]
     
            eventTagsRef.document("tag1").setData(tag1)
            eventTagsRef.document("tag2").setData(tag2)
            eventTagsRef.document("tag3").setData(tag3)
            
            // Create sample Events
            let eventsRef = db.collection("events")
            let event1 = [
                "startTime": Timestamp(date: Date()),
                "endTime": Timestamp(date: Date().addingTimeInterval(3600)), // 1 hour later
                "eventTags": [eventTagsRef.document("tag1"), eventTagsRef.document("tag3")], // References
                "rsvpList": [usersRef.document("user1")],
                "createdBy": usersRef.document("user2"), // References
                "name": "Concert Night",
                "description": "A wonderful music concert to enjoy!",
                "pictures": ["bucket/event_pictures/concert1.jpg", "bucket/event_pictures/concert2.jpg"],
                "location": GeoPoint(latitude: 37.7749, longitude: -122.4194) // Example: San Francisco
            ] as [String: Any]
     
            let event2 = [
                "startTime": Timestamp(date: Date().addingTimeInterval(86400)), // Tomorrow
                "endTime": Timestamp(date: Date().addingTimeInterval(90000)), // 1 hour after start
                "eventTags": [eventTagsRef.document("tag2")], // Reference
                "rsvpList": [usersRef.document("user2")],
                "createdBy": usersRef.document("user1"), // Reference
                "name": "Football Match",
                "description": "Join us for an exciting football match.",
                "pictures": ["bucket/event_pictures/match1.jpg"],
                "location": GeoPoint(latitude: 40.7128, longitude: -74.0060) // Example: New York
            ] as [String: Any]
     
            eventsRef.document("event1").setData(event1)
            eventsRef.document("event2").setData(event2)
            
            // Update user events and RSVPs
            usersRef.document("user1").updateData([
                "createdByYou": [eventsRef.document("event1")],
                "rsvpByYou": [eventsRef.document("event2")]
            ])
            usersRef.document("user2").updateData([
                "createdByYou": [eventsRef.document("event2")],
                "rsvpByYou": [eventsRef.document("event1")]
            ])
        }


}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "events", for: indexPath) as! TableViewEventCell
        // Need to figure out a way to set the variables to each of the cells
        cell.labelName.text = activeEvents[indexPath.row].name
        cell.labelDate.text = activeEvents[indexPath.row].startTime.description
        cell.imageReceipt.image = UIImage(systemName: "person.circle")
        cell.labelDescription.text = activeEvents[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = activeEvents[indexPath.row]
        let detailVC = EventDetailViewController()
        detailVC.event = selectedEvent
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension MKMapView{
    func centerToLocation(location: CLLocation, radius: CLLocationDistance = 1000){
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: radius,
            longitudinalMeters: radius
        )
        setRegion(coordinateRegion, animated: true)
    }
}
