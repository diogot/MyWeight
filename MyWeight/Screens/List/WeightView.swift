//
//  WeightView
//  MyWeight
//
//  Created by Diogo on 12/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public class WeightView: UIView, ViewModelOwner {

    let weightLabel: UILabel
    let dateLabel: UILabel

    let style: StyleProvider

    override public init(frame: CGRect)
    {
        weightLabel = UILabel()
        dateLabel = UILabel()
        style = Style()
        viewModel = WeightViewModel()

        super.init(frame: frame)

        setUp()
        updateView()
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp()
    {
        let contentView = self
        contentView.setContentHuggingPriority(UILayoutPriorityRequired,
                                              for: .vertical)
        contentView.setContentCompressionResistancePriority(UILayoutPriorityRequired,
                                                            for: .vertical)

        let grid = style.grid

        contentView.addSubview(weightLabel)
        weightLabel.translatesAutoresizingMaskIntoConstraints = false

        weightLabel.setContentHuggingPriority(UILayoutPriorityRequired,
                                              for: .horizontal)
        weightLabel.setContentHuggingPriority(UILayoutPriorityRequired,
                                              for: .vertical)

        weightLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: grid*3).isActive = true
        weightLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -grid*3).isActive = true
        weightLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: grid*4).isActive = true

        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        dateLabel.setContentHuggingPriority(UILayoutPriorityRequired,
                                            for: .horizontal)
        dateLabel.setContentHuggingPriority(UILayoutPriorityRequired,
                                            for: .vertical)

        dateLabel.centerYAnchor.constraint(equalTo: weightLabel.centerYAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -grid*4).isActive = true

        dateLabel.numberOfLines = 0
        dateLabel.textAlignment = .right

        self.backgroundColor = style.backgroundColor
    }

    public var viewModel: WeightViewModel {
        didSet {
            updateView()
        }
    }

    func updateView()
    {
        weightLabel.attributedText = viewModel.weight
        dateLabel.attributedText = viewModel.date
    }

}
