import UIKit

class TableViewEventCell: UITableViewCell {

    var wrapperCellView: UIView!
    var labelName: UILabel!
    var labelDate: UILabel!
    var imageReceipt: UIImageView!
    var labelDescription: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupWrapperCellView()
        setupLabelName()
        setupLabelDate()
        setupImageReceipt()
        setupLabelDescription()
        initConstraints()

    }
    
    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 4.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 2.0
        wrapperCellView.layer.shadowOpacity = 0.7
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelName(){
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 6)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.numberOfLines = 1
        labelName.lineBreakMode = .byTruncatingTail
        wrapperCellView.addSubview(labelName)
    }
    
    func setupLabelDate(){
        labelDate = UILabel()
        labelDate.font = UIFont.boldSystemFont(ofSize: 6)
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        labelDate.numberOfLines = 1
        labelDate.lineBreakMode = .byTruncatingTail
        wrapperCellView.addSubview(labelDate)
    }
    
    func setupImageReceipt(){
        imageReceipt = UIImageView()
        imageReceipt.image = UIImage(systemName: "photo")
        imageReceipt.contentMode = .scaleAspectFit
        imageReceipt.clipsToBounds = true
        imageReceipt.layer.cornerRadius = 10
        imageReceipt.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(imageReceipt)
    }
    
    func setupLabelDescription(){
        labelDescription = UILabel()
        labelDescription.font = UIFont.boldSystemFont(ofSize: 6)
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        labelDescription.numberOfLines = 1
        labelDescription.lineBreakMode = .byTruncatingTail
        wrapperCellView.addSubview(labelDescription)
    }
    
    
    func initConstraints(){
        
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                        
            labelName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 2),
            labelName.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 8),
            labelName.heightAnchor.constraint(equalToConstant: 32),
            labelName.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
                        
            labelDate.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 2),
            labelDate.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: 8),
            labelDate.heightAnchor.constraint(equalToConstant: 32),
            labelDate.widthAnchor.constraint(lessThanOrEqualTo: labelName.widthAnchor),
                        
            labelDescription.topAnchor.constraint(equalTo: imageReceipt.bottomAnchor, constant: -20),
            labelDescription.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor),
            labelDescription.heightAnchor.constraint(equalToConstant: 32),
            labelDescription.widthAnchor.constraint(lessThanOrEqualTo: labelName.widthAnchor),
                        
            imageReceipt.leadingAnchor.constraint(equalTo: labelName.leadingAnchor, constant: 8),
            imageReceipt.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            imageReceipt.heightAnchor.constraint(equalTo: wrapperCellView.heightAnchor, constant: -20),
            imageReceipt.widthAnchor.constraint(equalTo: wrapperCellView.heightAnchor, constant: -20),
                        
            wrapperCellView.heightAnchor.constraint(equalToConstant: 208)
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

