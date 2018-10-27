//
//  ListView.swift
//  MyWeight
//
//  Created by Diogo on 09/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public class ListView: UIView {

    typealias Cell = TableViewCell<MassView, MassViewModel>

    let topShadow = GradientView()
    let tableView: UITableView
    let buttonTopShadow = GradientView()
    let addButton: TintButton = TintButton()
    let style: StyleProvider = Style()

    public var viewModel: ListViewModelProtocol = ListViewModel() {
        didSet {
            update()
        }
    }

    override public init(frame: CGRect)
    {
        tableView = UITableView(frame: frame, style: .grouped)
        super.init(frame: frame)
        setUp()
        update()
    }

    public var topOffset: CGFloat {
        set(topOffset) {
            topConstraint?.constant = topOffset
        }

        get {
            return topConstraint?.constant ?? 0
        }
    }

    var topConstraint: NSLayoutConstraint?


    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp()
    {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        if #available(iOS 11.0, *) {
            contentView.topAnchor
                .constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
            contentView.leftAnchor
                .constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
            contentView.rightAnchor
                .constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
            contentView.bottomAnchor
                .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            topConstraint = contentView.topAnchor.constraint(equalTo: topAnchor)
            topConstraint?.isActive = true
            contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }

        let backgroundColor = style.backgroundColor
        let grid = style.grid
        self.backgroundColor = backgroundColor
        contentView.backgroundColor = backgroundColor

        contentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        tableView.allowsSelection = false

        tableView.registerCellClass(Cell.self)
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = grid * 11

        tableView.dataSource = self
        tableView.delegate = self

        tableView.backgroundColor = backgroundColor

        tableView.separatorStyle = .none
        
        contentView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = grid * 2
        addButton.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: padding) .isActive = true
        addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                            constant: -padding).isActive = true
        addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                              constant: -padding).isActive = true

        addButton.addTarget(self,
                            action: #selector(ListView.buttonTap),
                            for: .touchUpInside)
        
        contentView.addSubview(buttonTopShadow)
        buttonTopShadow.translatesAutoresizingMaskIntoConstraints = false
        buttonTopShadow.heightAnchor.constraint(equalToConstant: grid * 4).isActive = true
        buttonTopShadow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor) .isActive = true
        buttonTopShadow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        buttonTopShadow.bottomAnchor.constraint(equalTo: addButton.topAnchor).isActive = true
        buttonTopShadow.colors = [backgroundColor, backgroundColor.withAlphaComponent(0)]
        buttonTopShadow.startPoint = CGPoint(x: 0.5, y: 1)
        buttonTopShadow.endPoint = CGPoint(x: 0.5, y: 0)

        contentView.addSubview(topShadow)
        topShadow.translatesAutoresizingMaskIntoConstraints = false
        topShadow.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        topShadow.heightAnchor.constraint(equalToConstant: grid * 4).isActive = true
        topShadow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor) .isActive = true
        topShadow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        topShadow.colors = [backgroundColor, backgroundColor.withAlphaComponent(0)]
        topShadow.startPoint = CGPoint(x: 0.5, y: 0)
        topShadow.endPoint = CGPoint(x: 0.5, y: 1)
    }


    func update()
    {
        addButton.title = viewModel.buttonTitle
        tableView.reloadData()
        if let emptyListViewModel = viewModel.emptyListViewModel {
            let backgroundView = TitleDescriptionView()
            backgroundView.viewModel = emptyListViewModel
            tableView.backgroundView = backgroundView
        } else {
            tableView.backgroundView = nil
        }
    }

    @objc func buttonTap()
    {
        viewModel.didTapAction()
    }

}

extension ListView: UITableViewDelegate, UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    public func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int
    {
        return Int(viewModel.items)
    }

    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.defaultReuseIdentifier,
                                                 for: indexPath) as! Cell

        cell.viewModel = viewModel.data(UInt(indexPath.row))

        return cell
    }

    public func tableView(_ tableView: UITableView,
                          heightForHeaderInSection section: Int) -> CGFloat
    {
        return CGFloat.leastNormalMagnitude
    }

    public func tableView(_ tableView: UITableView,
                          canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }

    public func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCell.EditingStyle,
                          forRowAt indexPath: IndexPath)
    {
        guard editingStyle == .delete else {
            return
        }
        
        viewModel.deleteAction(UInt(indexPath.item))
    }

}
