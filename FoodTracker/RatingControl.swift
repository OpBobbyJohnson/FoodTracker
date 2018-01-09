//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Dylan Martin on 1/4/18.
//  Copyright © 2018 Dylan Martin. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet{
            updateButtonSelectionStates()
        }
    }
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet{
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5{
        didSet{
            setupButtons()
        }
    }
    //MARK: Initialization
    override init(frame: CGRect) {
        // calls the superclass's initalizer
        super.init(frame: frame)
        setupButtons()
        
    }
    
    required init(coder: NSCoder) {
        // calls the superclass's initalizer
        super.init(coder: coder)
        setupButtons()
    }
    //MARK: Private Methods
    private func setupButtons(){
        //Clear all existing buttons
        for button in ratingButtons{
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        for index in 0..<starCount {
            //Create the Button
            let button = UIButton()
            //Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            // Add Constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            //Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            // Add the button to the stack
            addArrangedSubview(button)
            // Add the new button tot he rating button array
            ratingButtons.append(button)
            button.accessibilityLabel = "set \(index+1) star rating"
        }
        //Updates buttons
        updateButtonSelectionStates()
    }
    
    //MARK: Button Actions
    @objc func ratingButtonTapped(button: UIButton){
        guard let index = ratingButtons.index(of: button) else{
            fatalError("thebutton, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        // calculate the rating of the selected button
        let selectedRating = index+1
        if selectedRating == rating{
            //If the selected star represents the current rating, reset the rating to 0
            rating = 0
        }
        else{
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
    }
    private func updateButtonSelectionStates(){
        for (index, button) in ratingButtons.enumerated(){
            //If the index fo a button is less than the rating, that boutton should be selected
            button.isSelected = index < rating
            //Set the hint string for the currently selected star
            let hintString : String?
            if rating == index+1{
                hintString = "Tap to reset the rating to zero"
            }
            else{
                hintString = nil
            }
            //Calculate the value string
            let valueString: String
            switch (rating){
            case 0:
                valueString = "No rating set"
            case 1:
                valueString = "1 star set"
            default:
                valueString = "\(rating) stars set"
            }
            //Assign the hint srting and string value
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}
