//
//  StudentLocationCell.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/15/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import UIKit

final class StudentLocationCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for studentInformation: StudentInformation) -> UITableViewCell {
        imageView?.image = UIImage(named: studentInformation.pinImageName)
        textLabel?.text = studentInformation.fullName
        detailTextLabel?.text = studentInformation.mediaURL
        return self
    }
}
