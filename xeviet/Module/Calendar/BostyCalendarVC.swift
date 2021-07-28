//
//  BostyCalendarVC.swift
//  bosty-ios
//
//  Created by eagle on 1/7/20.
//  Copyright © 2020 Tran Thanh Nhien. All rights reserved.
//

import JTAppleCalendar
import UIKit

class BostyCalendarVC: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    @IBOutlet var jtCalendarView: JTAppleCalendarView!
    @IBOutlet var btnPrevMonth: UIButton!
    @IBOutlet var btnNextMonth: UIButton!
    @IBOutlet var labelMonth: UILabel!
    
    var minDate: Date!
    var maxDate: Date!
    var didPickDate: ([Date]) -> Void
    
    var isRange:Bool!
    let testCalendar = Calendar(identifier: .gregorian)
    var firstDate: Date?
    var twoDatesAlreadySelected: Bool {
       return firstDate != nil && jtCalendarView.selectedDates.count > 1
    }
    
    init(isRange: Bool = false, pickDateBlock: @escaping ([Date]) -> Void) {
        self.didPickDate = pickDateBlock
        self.isRange = isRange
        super.init(nibName: "BostyCalendarVC", bundle: nil)
    }
    
    init(minDate: Date, maxDate: Date, isRange: Bool = false, pickDateBlock: @escaping ([Date]) -> Void) {
        self.didPickDate = pickDateBlock
        self.minDate = minDate
        self.maxDate = maxDate
        self.isRange = isRange
        super.init(nibName: "BostyCalendarVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jtCalendarView.register(UINib(nibName: DateCell.nameOfClass, bundle: nil), forCellWithReuseIdentifier: "dateCell")
        jtCalendarView.ibCalendarDataSource = self
        jtCalendarView.ibCalendarDelegate = self
        jtCalendarView.scrollDirection = .horizontal
        jtCalendarView.scrollingMode = .stopAtEachCalendarFrame
        jtCalendarView.showsHorizontalScrollIndicator = false
        jtCalendarView.allowsMultipleSelection = false
        jtCalendarView.isRangeSelectionUsed = false
        
        let now = Date()
        self.labelMonth.text = now.toJpYearDate
        
        if self.isRange{
            jtCalendarView.allowsMultipleSelection = true
            jtCalendarView.isRangeSelectionUsed = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        jtCalendarView.scrollToDate(Date(), triggerScrollToDateDelegate: true, animateScroll: false) {
            
        }
    }
    
    @IBAction func on_background(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnPrevClicked(_ sender: Any) {
        self.jtCalendarView?.scrollToSegment(.previous, animateScroll: true)
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        self.jtCalendarView?.scrollToSegment(.next, animateScroll: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

extension BostyCalendarVC {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = TimeZone(identifier: "UTC")!
        let startDate = self.minDate ?? Date()
        let endDate = self.maxDate ?? formatter.date(from: "2030 01 01")!
        
        let config = ConfigurationParameters(startDate: startDate,
                                             endDate: endDate,
                                             numberOfRows: 6,
                                             generateInDates: .forAllMonths,
                                             generateOutDates: .off,
                                             firstDayOfWeek: .monday,
                                             hasStrictBoundaries: true)
        return config
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! DateCell
        cell.dateLabel.text = cellState.text
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        cell.dateLabel.text = cellState.text
        configureCell(view: cell, cellState: cellState)
        return cell
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.day == .saturday {
            cell.dateLabel.textColor = UIColor.blue
        } else if cellState.day == .sunday {
            cell.dateLabel.textColor = UIColor.red
        } else {
            cell.dateLabel.textColor = UIColor.white
        }
        
        if self.minDate != nil{
            if cellState.date < self.minDate {
                cell.dateLabel.alpha = 0.3
            }else{
                cell.dateLabel.alpha = 1.0
            }
        }
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.backgroundColor = UIColor.red
            cell.selectedView.layer.cornerRadius = cell.selectedView.layer.frame.size.width / 2
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.backgroundColor = UIColor.clear
            cell.selectedView.isHidden = true
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if self.minDate != nil{
            if cellState.date < self.minDate {
                return
            }else{
                if firstDate != nil {
                          calendar.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
                      } else {
                          firstDate = date
                      }
                
                configureCell(view: cell, cellState: cellState)
            }
        }
        if firstDate != nil {
                  calendar.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
              } else {
                  firstDate = date
              }
        
        configureCell(view: cell, cellState: cellState)

        if !self.isRange{
            didPickDate(calendar.selectedDates)
            presentingViewController!.dismiss(animated: true, completion: nil)
        }else{
            if calendar.selectedDates.count > 1{
                didPickDate(calendar.selectedDates)
                presentingViewController!.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
//    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
//        if self.minDate != nil{
//            if date < self.minDate{
//                self.minDate = date
//                
//                if twoDatesAlreadySelected && cellState.selectionType != .programatic || firstDate != nil && date < calendar.selectedDates[0] {
//                               firstDate = nil
//                               let retval = !calendar.selectedDates.contains(date)
//                               calendar.deselectAllDates()
//                               return retval
//                           }
//                
//                return true
//            }else{
//                return true
//            }
//        }else{
//            self.minDate = date
//            if twoDatesAlreadySelected && cellState.selectionType != .programatic || firstDate != nil && date < calendar.selectedDates[0] {
//                firstDate = nil
//                let retval = !calendar.selectedDates.contains(date)
//                calendar.deselectAllDates()
//                return retval
//            }
//            return true
//        }
////        return true // Based on a criteria, return true or false
//    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
           if twoDatesAlreadySelected && cellState.selectionType != .programatic {
               firstDate = nil
               calendar.deselectAllDates()
               return false
           }
           return true
       }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let monthDate = visibleDates.monthDates.first?.date
        labelMonth.text = monthDate?.toJpYearDate
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let monthDate = visibleDates.monthDates.first?.date
        labelMonth.text = monthDate?.toJpYearDate
    }
}
