//
//  SortOptionView.swift
//  GithubList
//
//  Created by kulraj singh on 19/04/25.
//

import UIKit

enum UserSortOrder {
    case ascending
    case descending
}

class SortOptionView: UIView {
    
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var ascendingButton: UIButton!
    @IBOutlet weak var descendingButton: UIButton!
    
    var selectedSortOrder = UserSortOrder.ascending {
        didSet {
            setSortOrderButtons()
            onOrderChange?(selectedSortOrder)
        }
    }
    
    var onTap: (() -> ())?
    var onOrderChange: ((UserSortOrder) -> ())?
    
    var sortOption: SortOption = .id {
        didSet {
            optionLabel.text = sortOption.rawValue.capitalized
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func initialize() {
        setSortOrderButtons()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    func setSortOrderButtons() {
        switch selectedSortOrder {
        case .ascending:
            ascendingButton.alpha = 1
            descendingButton.alpha = 0.4
        case .descending:
            ascendingButton.alpha = 0.4
            descendingButton.alpha = 1
        }
    }
    
    @IBAction func ascendinTapped(_ sender: Any) {
        selectedSortOrder = .ascending
        onTap?()
    }
    
    @IBAction func descendingTapped(_ sender: Any) {
        selectedSortOrder = .descending
        onTap?()
    }
    
    @objc func viewTapped() {
        onTap?()
        selectedSortOrder = .ascending
    }
    
    func setColors(selectedSortOption: SortOption) {
        if selectedSortOption == sortOption {
            backgroundColor = .link
            optionLabel.textColor = .white
            ascendingButton.tintColor = .white
            descendingButton.tintColor = .white
        } else {
            backgroundColor = .white
            optionLabel.textColor = .black
            ascendingButton.tintColor = .white
            descendingButton.tintColor = .white
        }
    }
}
