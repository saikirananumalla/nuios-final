//
//  EventDetailView.swift
//  final
//
//  Created by Sai Kiran Anumalla on 06/12/24.
//


import UIKit
import MapKit

class EventDetailView: UIView {

    // UI Components
    let scrollView = UIScrollView()
    let contentView = UIView()

    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let dateTimeLabel = UILabel()
    let locationMap = MKMapView()
    let tagsLabel = UILabel()
    let rsvpLabel = UILabel()
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white

        // ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Name Label
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.numberOfLines = 0
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        // Description Label
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)

        // Date and Time Label
        dateTimeLabel.font = .italicSystemFont(ofSize: 14)
        dateTimeLabel.numberOfLines = 0
        dateTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateTimeLabel)

        // Map View
        locationMap.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(locationMap)

        // Tags Label
        tagsLabel.font = .systemFont(ofSize: 16)
        tagsLabel.numberOfLines = 0
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tagsLabel)

        // RSVP Label
        rsvpLabel.font = .systemFont(ofSize: 16)
        rsvpLabel.numberOfLines = 0
        rsvpLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rsvpLabel)

        // Image View
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView Constraints
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Name Label
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Date and Time Label
            dateTimeLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            dateTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Map View
            locationMap.topAnchor.constraint(equalTo: dateTimeLabel.bottomAnchor, constant: 20),
            locationMap.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            locationMap.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            locationMap.heightAnchor.constraint(equalToConstant: 200),

            // Tags Label
            tagsLabel.topAnchor.constraint(equalTo: locationMap.bottomAnchor, constant: 20),
            tagsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tagsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // RSVP Label
            rsvpLabel.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 20),
            rsvpLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            rsvpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Image View
            imageView.topAnchor.constraint(equalTo: rsvpLabel.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
