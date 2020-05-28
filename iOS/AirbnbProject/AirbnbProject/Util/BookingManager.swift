//
//  BookingManager.swift
//  AirbnbProject
//
//  Created by 임승혁 on 2020/05/28.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import Foundation

class BookingManager {
    var firstSelectedCellIndexPath: IndexPath?
    var secondSelectedCellIndexPath: IndexPath?
    
    var selectedIndexPath = [IndexPath]()
    var selectedCells = [IndexPath : DayCollectionViewCell]()
    
    func initializeCell(indexPath: IndexPath) {
        self.secondSelectedCellIndexPath = nil
        self.firstSelectedCellIndexPath = nil
        self.selectedCells[indexPath] = nil
    }
    
    func isSelectedCell(indexPath: IndexPath, cell: DayCollectionViewCell) -> Bool {
        if selectedCells[indexPath] == cell {
            self.initializeCell(indexPath: indexPath)
            return true
        } else {
            return false
        }
    }
    
    // 첫번째 셀 지정
    func setFisrtSelectedIndexPath(indexPath: IndexPath, cell: DayCollectionViewCell) {
        self.selectedCells[indexPath] = cell
        self.selectedIndexPath.append(indexPath)
        self.firstSelectedCellIndexPath = self.selectedIndexPath[0]
    }
    
    //
    func isSelectable(indexPath: IndexPath) {
        if self.firstSelectedCellIndexPath! > indexPath {
            selectedCells[firstSelectedCellIndexPath!]?.initializeBackgroundView()
            self.initializeCell(indexPath: firstSelectedCellIndexPath!)
            
            selectedIndexPath.remove(at: 0)
            self.firstSelectedCellIndexPath = indexPath
            selectedCells[indexPath]?.updateSelectedCellBackgroundView()
        }
    }
}
