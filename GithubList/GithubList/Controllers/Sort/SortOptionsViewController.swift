//
//  SortOptionsViewController.swift
//  GithubList
//
//  Created by kulraj singh on 19/04/25.
//

import UIKit

enum SortOption: String {
    case login = "Sort by Login Name"
    case id = "Sort by Id"
    case none
}

class SortOptionsViewController: UIViewController {
    
    @IBOutlet weak var sortOptionsStackView: UIStackView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var selectedSortOption: SortOption = .none {
        didSet {
            applyColorToUi()
        }
    }
    var onClose: (() -> ())?
    var onApply: ((SortOption, UserSortOrder) -> ())?
    var sortOptionViews: [SortOptionView] = []
    var sortOptions: [SortOption] = []
    var selectedSortOrder = UserSortOrder.ascending {
        didSet {
            for sortOptionView in sortOptionViews {
                if selectedSortOption != sortOptionView.sortOption {
                    sortOptionView.ascendingButton.alpha = 0.4
                    sortOptionView.descendingButton.alpha = 0.4
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sortOptions = [.id, .login]
        addSortOptions()
        applyColorToUi()
        roundCorners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for sortOptionView in sortOptionViews {
            sortOptionView.selectedSortOrder = selectedSortOrder
        }
    }

    func addSortOptions() {
        sortOptionViews.removeAll()
        for sortOption in sortOptions {
            let sortOptionView = Bundle.main.loadNibNamed("SortOptionView", owner: self)?.last! as! SortOptionView
            sortOptionView.sortOption = sortOption
            sortOptionView.onTap = { [weak self] in
                self?.selectedSortOption = sortOption
            }
            sortOptionView.onOrderChange = { [weak self] order in
                self?.selectedSortOrder = order
            }
            sortOptionViews.append(sortOptionView)
            sortOptionsStackView.addArrangedSubview(sortOptionView)
        }
    }
    
    func applyColorToUi() {
        for sortOptionView in sortOptionViews {
            sortOptionView.setColors(selectedSortOption: selectedSortOption)
        }
    }
    
    func roundCorners() {
        applyButton.layer.cornerRadius = applyButton.frame.height/2
        applyButton.layer.masksToBounds = true
        resetButton.layer.cornerRadius = resetButton.frame.height/2
        resetButton.layer.masksToBounds = true
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        onClose?()
    }
    
    @IBAction func applyTapped(_ sender: Any) {
        onApply?(selectedSortOption, selectedSortOrder)
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        selectedSortOption = .none
    }
}
