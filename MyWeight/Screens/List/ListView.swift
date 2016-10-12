//
//  ListView.swift
//  MyWeight
//
//  Created by Diogo on 09/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public class ListView: UIView {

    let tableView: UITableView
    let addButton: TintButton
    let style = Style()

    public var viewModel: ListViewModelProtocol = ListViewModel() {
        didSet {
            updateView()
        }
    }

    public override init(frame: CGRect)
    {
        tableView = UITableView(frame: frame, style: .grouped)
        addButton = TintButton()
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

        tableView.dataSource = self
        tableView.delegate = self

        tableView.backgroundColor = style.backgroundColor

        contentView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = style.grid * 2
        addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding) .isActive = true
        addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
        addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true

        addButton.addTarget(self,
                            action: #selector(ListView.buttonTap),
                            for: .touchUpInside)
    }


    func updateView()
    {
        addButton.title = viewModel.buttonTitle
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

        let weight = viewModel.data(UInt(indexPath.row))

        cell.textLabel?.text = "\(weight.value.value) kg - \(weight.date)"

        return cell
    }

}
