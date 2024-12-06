//
//  EventDetailViewController.swift
//  final
//
//  Created by Sai Kiran Anumalla on 06/12/24.
//


import UIKit
import MapKit

class EventDetailViewController: UIViewController {

    let detailView = EventDetailView()
    var event: Event! // Pass the event data from the homepage

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        populateEventDetails()
    }

    private func populateEventDetails() {
        detailView.nameLabel.text = event.name
        detailView.descriptionLabel.text = event.description
        detailView.dateTimeLabel.text = "From \(event.startTime.dateValue()) to \(event.endTime.dateValue())"

        // Show the location on the map
        let coordinate = CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        detailView.locationMap.addAnnotation(annotation)
        detailView.locationMap.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500), animated: false)

        // Show tags
        detailView.tagsLabel.text = "Tags: \(event.eventTags.map { $0.path }.joined(separator: ", "))"

        // Show RSVP list
        detailView.rsvpLabel.text = "RSVP: \(event.rsvpList.count) people"

        // Show the first image (if available)
        if let imageURL = event.pictures.first {
            fetchImage(from: imageURL) { [weak self] image in
                self?.detailView.imageView.image = image
            }
        }
    }

    private func fetchImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: URL(string: url)!), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
