import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class CreateEventViewController: UIViewController {
    
    let createEventPage = CreateEventScreen()
    var selectedImages = [UIImage]()
    let childProgressView = ProgressSpinnerViewController()
    
    override func loadView() {
        self.view = createEventPage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Event"
        
        createEventPage.textFieldTags.delegate = self
        createEventPage.collectionViewTags.dataSource = self
        createEventPage.collectionViewTags.delegate = self
        createEventPage.collectionViewTags.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
        
        createEventPage.buttonAddImage.addTarget(self, action: #selector(onAddImagePressed), for: .touchUpInside)
        createEventPage.buttonSelectLocation.addTarget(self, action: #selector(onSelectLocationPressed), for: .touchUpInside)
        createEventPage.buttonSubmit.addTarget(self, action: #selector(onSubmitPressed), for: .touchUpInside)
    }
    
    func showDetailsInAlert(errorMessage: String){
        let alert = UIAlertController(title: "Error!", message: "\(errorMessage)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    @objc func onAddImagePressed() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func onSelectLocationPressed() {
        let locationPicker = LocationPickerViewController()
        locationPicker.delegate = self
        self.navigationController?.pushViewController(locationPicker, animated: true)
    }
    
    @objc func onSubmitPressed() {
        self.showActivityIndicator()
        
        guard let name = createEventPage.textFieldName.text, !name.isEmpty else {
            print("Event name is required.")
            return
        }
        let location = createEventPage.selectedLocation ?? GeoPoint(latitude: 0, longitude: 0)
        let userID = Auth.auth().currentUser?.uid
        let userDocumentRef = Firestore.firestore().collection("users").document(userID ?? "")
        let event = Event(
            id: nil,
            startTime: Timestamp(date: createEventPage.datePickerStartTime.date),
            endTime: Timestamp(date: createEventPage.datePickerEndTime.date),
            eventTags: createEventPage.selectedTags.map { Firestore.firestore().collection("tags").document($0) },
            rsvpList: [],
            name: name,
            description: createEventPage.textViewDescription.text ?? "",
            pictures: [],
            location: location,
            createdBy: userDocumentRef // Reference to the current user's document
        )
        saveEventToFirebase(event: event, images: selectedImages) { success in
            if success {
                self.hideActivityIndicator()
                print("In success")
                NotificationCenter.default.post(name: Notification.Name("addFromAddEventScreen"), object: nil)
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showDetailsInAlert(errorMessage: "Error saving event: check inputs")
                self.hideActivityIndicator()
                print("Failed to save event.")
            }
        }
    }
}

extension CreateEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImages.append(image)
            createEventPage.imageViewSelected.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CreateEventViewController: LocationPickerDelegate {
    func didPickLocation(latitude: Double, longitude: Double) {
        print("Selected location: \(latitude), \(longitude)")
        createEventPage.selectedLocation = GeoPoint(latitude: latitude, longitude: longitude)
        createEventPage.labelSelectedLocation.text = "Lat: \(latitude), Long: \(longitude)"
    }
}

extension CreateEventViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let tag = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !tag.isEmpty else {
            return false
        }
        createEventPage.selectedTags.append(tag)
        createEventPage.collectionViewTags.reloadData()
        textField.text = "" // Clear the text field
        return true
    }
}


extension CreateEventViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return createEventPage.selectedTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        cell.label.text = createEventPage.selectedTags[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = createEventPage.selectedTags[indexPath.item]
        let width = tag.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]).width + 20
        return CGSize(width: width, height: 30)
    }
}

extension CreateEventViewController:ProgressSpinnerDelegate{
    func showActivityIndicator(){
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator(){
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}
