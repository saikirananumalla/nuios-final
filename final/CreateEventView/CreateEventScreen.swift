import UIKit
import FirebaseFirestore

class CreateEventScreen: UIView {

    var scrollView: UIScrollView!
    var contentView: UIView!

    var textFieldName: UITextField!
    var textViewDescription: UITextView!
    var datePickerStartTime: UIDatePicker!
    var datePickerEndTime: UIDatePicker!
    var buttonAddImage: UIButton!
    var imageViewSelected: UIImageView!
    var buttonSelectLocation: UIButton!
    var labelSelectedLocation: UILabel!
    var buttonSubmit: UIButton!
    var selectedLocation: GeoPoint?
    var textFieldTags: UITextField!
    var collectionViewTags: UICollectionView!
    var selectedTags = [String]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        self.backgroundColor = .white
        
        // Create and add UIScrollView
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        // Create and add contentView
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        // Event Name Field
        textFieldName = UITextField()
        textFieldName.placeholder = "Event Name"
        textFieldName.borderStyle = .roundedRect
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textFieldName)

        // Description Field
        textViewDescription = UITextView()
        textViewDescription.layer.borderWidth = 1.0
        textViewDescription.layer.borderColor = UIColor.lightGray.cgColor
        textViewDescription.layer.cornerRadius = 8.0
        textViewDescription.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textViewDescription)

        // Start Time Picker
        datePickerStartTime = UIDatePicker()
        datePickerStartTime.datePickerMode = .dateAndTime
        datePickerStartTime.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(datePickerStartTime)

        // End Time Picker
        datePickerEndTime = UIDatePicker()
        datePickerEndTime.datePickerMode = .dateAndTime
        datePickerEndTime.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(datePickerEndTime)

        // Add Image Button
        buttonAddImage = UIButton(type: .system)
        buttonAddImage.setTitle("Add Image", for: .normal)
        buttonAddImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonAddImage)

        // Selected Image Preview
        imageViewSelected = UIImageView()
        imageViewSelected.contentMode = .scaleAspectFit
        imageViewSelected.layer.borderWidth = 1.0
        imageViewSelected.layer.borderColor = UIColor.lightGray.cgColor
        imageViewSelected.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageViewSelected)

        // Select Location Button
        buttonSelectLocation = UIButton(type: .system)
        buttonSelectLocation.setTitle("Select Location", for: .normal)
        buttonSelectLocation.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonSelectLocation)

        // Selected Location Label
        labelSelectedLocation = UILabel()
        labelSelectedLocation.text = "No location selected"
        labelSelectedLocation.textAlignment = .center
        labelSelectedLocation.textColor = .darkGray
        labelSelectedLocation.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelSelectedLocation)

        // Tags Input Field
        textFieldTags = UITextField()
        textFieldTags.placeholder = "Add a tag and press Enter"
        textFieldTags.borderStyle = .roundedRect
        textFieldTags.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textFieldTags)

        // Tags Collection View
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionViewTags = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionViewTags.backgroundColor = .white
        collectionViewTags.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionViewTags)

        // Submit Button
        buttonSubmit = UIButton(type: .system)
        buttonSubmit.setTitle("Create Event", for: .normal)
        buttonSubmit.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonSubmit)

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView Constraints
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            // ContentView Constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Individual Elements Constraints
            textFieldName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            textFieldName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textFieldName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            textViewDescription.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 20),
            textViewDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textViewDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textViewDescription.heightAnchor.constraint(equalToConstant: 100),

            datePickerStartTime.topAnchor.constraint(equalTo: textViewDescription.bottomAnchor, constant: 20),
            datePickerStartTime.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            datePickerStartTime.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            datePickerEndTime.topAnchor.constraint(equalTo: datePickerStartTime.bottomAnchor, constant: 20),
            datePickerEndTime.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            datePickerEndTime.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            buttonAddImage.topAnchor.constraint(equalTo: datePickerEndTime.bottomAnchor, constant: 20),
            buttonAddImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            imageViewSelected.topAnchor.constraint(equalTo: buttonAddImage.bottomAnchor, constant: 20),
            imageViewSelected.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageViewSelected.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageViewSelected.heightAnchor.constraint(equalToConstant: 200),

            labelSelectedLocation.topAnchor.constraint(equalTo: imageViewSelected.bottomAnchor, constant: 20),
            labelSelectedLocation.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            labelSelectedLocation.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            labelSelectedLocation.heightAnchor.constraint(equalToConstant: 50),

            buttonSelectLocation.topAnchor.constraint(equalTo: labelSelectedLocation.bottomAnchor, constant: 20),
            buttonSelectLocation.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            textFieldTags.topAnchor.constraint(equalTo: buttonSelectLocation.bottomAnchor, constant: 20),
            textFieldTags.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textFieldTags.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            collectionViewTags.topAnchor.constraint(equalTo: textFieldTags.bottomAnchor, constant: 10),
            collectionViewTags.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            collectionViewTags.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            collectionViewTags.heightAnchor.constraint(equalToConstant: 50),

            buttonSubmit.topAnchor.constraint(equalTo: collectionViewTags.bottomAnchor, constant: 20),
            buttonSubmit.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonSubmit.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
