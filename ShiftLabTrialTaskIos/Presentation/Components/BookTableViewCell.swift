//
//  BookTableViewCell.swift
//  ShiftLabTrialTaskIos
//
//  Created by Станислав Дейнекин on 19.10.2024.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    let bookImageView = UIImageView()
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    let genreLabel = UILabel()
    let descriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        bookImageView.contentMode = .scaleAspectFit
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        bookImageView.clipsToBounds = true
        bookImageView.layer.cornerRadius = 8
        contentView.addSubview(bookImageView)
        NSLayoutConstraint.activate([
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bookImageView.widthAnchor.constraint(equalToConstant: 134),
            bookImageView.heightAnchor.constraint(equalToConstant: 143)
        ])

        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        ])

        authorLabel.font = UIFont.systemFont(ofSize: 14)
        authorLabel.textColor = .gray
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(authorLabel)
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4)
        ])
        
        genreLabel.font = UIFont.systemFont(ofSize: 14)
        genreLabel.textColor = .gray
        genreLabel.numberOfLines = 0
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(genreLabel)
        NSLayoutConstraint.activate([
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            genreLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 4)
        ])
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = .grayFaded
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 4)
        ])
    }

    func configure(with book: Book, expanded: Bool) {
        titleLabel.text = book.title
        authorLabel.text = book.author
        genreLabel.text = book.genre
        descriptionLabel.text = book.description
        
        genreLabel.isHidden = !expanded
        descriptionLabel.isHidden = !expanded
        
        bookImageView.image = UIImage(named: "bookIcon")
    }
}
