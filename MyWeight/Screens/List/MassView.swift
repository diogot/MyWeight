//
//  MassView
//  MyWeight
//
//  Created by Diogo on 12/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public class MassView: UIView, ViewModelOwner {

    let massLabel: UILabel
    let dateLabel: UILabel

    let style: StyleProvider

    override public init(frame: CGRect)
    {
        massLabel = UILabel()
        dateLabel = UILabel()
        style = Style()
        viewModel = MassViewModel()

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
       
        let line = UIView()
        line.backgroundColor = style.separatorColor

        contentView.addSubview(massLabel)
        
        massLabel.translatesAutoresizingMaskIntoConstraints = false

        massLabel.setContentHuggingPriority(UILayoutPriorityRequired,
                                              for: .horizontal)
        massLabel.setContentHuggingPriority(UILayoutPriorityRequired,
                                              for: .vertical)

        massLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: grid*3).isActive = true
        massLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -grid*3).isActive = true
        massLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: grid*4).isActive = true

        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        dateLabel.setContentHuggingPriority(UILayoutPriorityRequired,
                                            for: .horizontal)
        dateLabel.setContentHuggingPriority(UILayoutPriorityRequired,
                                            for: .vertical)

        dateLabel.centerYAnchor.constraint(equalTo: massLabel.centerYAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -grid*4).isActive = true

        dateLabel.numberOfLines = 0
        dateLabel.textAlignment = .right
        
        contentView.addSubview(line)
        
        line.translatesAutoresizingMaskIntoConstraints = false
        
        line.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: grid*4).isActive = true
        line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -grid*4).isActive = true
        line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
       
        line.widthAnchor.constraint(equalToConstant: 100).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true

        self.backgroundColor = style.backgroundColor
    }
    
    public var viewModel: MassViewModel {
        didSet {
            updateView()
        }
    }

    func updateView()
    {
        massLabel.attributedText = viewModel.mass
        dateLabel.attributedText = viewModel.date
    }
    

}
