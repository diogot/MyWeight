//
//  ListView.swift
//  MyWeight
//
//  Created by Diogo on 09/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public protocol ListViewModelProtocol {

    var items: UInt { get }
    var data: (_ item: UInt) -> (weight: Double, date: String) { get }

    var buttonTitle: String { get }
//    var noDataTitle: String { get }
//    var noDataDescription: String { get }

    var didTapAction: () -> Void { get }

}

struct EmptyListViewModel: ListViewModelProtocol {

    let items: UInt = 0

    let data: (UInt) -> (weight: Double, date: String) = { _ in
        return (0, "bla")
    }

    let buttonTitle: String = "Add"

    let didTapAction: () -> Void = {Log.debug("Add button tap")}

}

public class ListView: UIView {

    let tableView: UITableView
    let addButton: UIButton

    var viewModel: ListViewModelProtocol = EmptyListViewModel() {
        didSet {
            updateView()
        }
    }

    public override init(frame: CGRect)
    {
        tableView = UITableView(frame: frame, style: .grouped)
        addButton = UIButton(type: .system)
        super.init(frame: frame)
        setUp()
        updateView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp()
    {
        let contentView = self

        contentView.addSubview(tableView)
        tableView.frame = contentView.frame
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.registerCellClass(UITableViewCell.self)

        contentView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 16
        addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding) .isActive = true
        addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
        addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 58).isActive = true

        tableView.dataSource = self
        tableView.delegate = self

        addButton.addTarget(self,
                            action: #selector(ListView.buttonTap),
                            for: .touchUpInside)
    }

    func updateView()
    {
        addButton.setTitle(viewModel.buttonTitle, for: .normal)
        tableView.reloadData()
    }

    func buttonTap()
    {
        viewModel.didTapAction()
    }

}

extension ListView: UITableViewDelegate, UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Int(viewModel.items)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.defaultReuseIdentifier,
                                                 for: indexPath)

        let data = viewModel.data(UInt(indexPath.row))

        cell.textLabel?.text = "\(data.weight) kg - \(data.date)"

        return cell
    }

}
