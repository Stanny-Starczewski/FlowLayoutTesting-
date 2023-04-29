import UIKit
import Foundation
import PlaygroundSupport

// Класс ячейки должен наследоваться от `UICollectionViewCell`.
// Ключевое слово final позволяет немного ускорить компиляцию и гарантирует, что от класса не будет никаких наследников.
final class ColorCell: UICollectionViewCell {
    
    // Идентификатор ячейки — используется для регистрации и восстановления:
    static let identifier = "ColorCell"
    
    // Конструктор:
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Закруглим края для ячейки:
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

// Основной класс, в котором мы будем выполнять эксперименты;
// он же является `UICollectionViewDataSource`, поставщиком данных для коллекции:
final class SupplementaryCollection: NSObject, UICollectionViewDataSource {
    
    private let colors: [UIColor] = [
        .black, .blue, .brown,
        .cyan, .green, .orange,
        .red, .purple, .yellow
    ]
    
    let count: Int
    
    init(count: Int) {
        self.count = count
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier,
                                                            
                                                            for: indexPath) as? ColorCell else {
            return UICollectionViewCell()
        }
        
        cell.prepareForReuse()
        
        // Произвольно выбираем цвет для фона ячейки:
        cell.contentView.backgroundColor = colors[Int.random(in: 0..<colors.count)]
        
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
}

// Размеры для коллекции:
let size = CGRect(origin: CGPoint(x: 0, y: 0),
                  size: CGSize(width: 300, height: 600))
// Указываем, какой Layout хотим использовать:
let layout = UICollectionViewFlowLayout()

let helper = SupplementaryCollection(count: 31)
let collection = UICollectionView(frame: size,
                                  collectionViewLayout: layout)
// Регистрируем ячейку в коллекции.
// Регистрируя ячейку, мы сообщаем коллекции, какими типами ячеек она может распоряжаться.
// При попытке создать ячейку с незарегистрированным идентификатором коллекция выдаст ошибку.
collection.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
collection.backgroundColor = .lightGray
collection.dataSource = helper

PlaygroundPage.current.liveView = collection

collection.reloadData()

