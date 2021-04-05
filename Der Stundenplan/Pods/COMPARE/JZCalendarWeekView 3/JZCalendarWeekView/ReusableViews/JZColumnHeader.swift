//
//  JZColumnHeader.swift
//  JZCalendarWeekView
//
//  Created by Jeff Zhang on 28/3/18.
//  Copyright © 2018 Jeff Zhang. All rights reserved.
//

import UIKit

/// Header for each column (section, day) in collectionView (Supplementary View)
open class JZColumnHeader: UICollectionReusableView {
    
    public var lblDay = UILabel()
    public var lblWeekday = UILabel()
    public var lblMonth = UILabel()
    
    let calendarCurrent = Calendar.current
    public var dateFormatter = DateFormatter()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        backgroundColor = .clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [lblMonth, lblDay, lblWeekday])
        stackView.axis = .vertical
        stackView.spacing = 0
        addSubview(stackView)
        stackView.setAnchorConstraintsEqualTo(centerXAnchor: centerXAnchor, centerYAnchor: centerYAnchor)
        lblDay.textAlignment = .center
        lblWeekday.textAlignment = .center
        lblMonth.textAlignment = .left
        lblDay.font = UIFont.systemFont(ofSize: 20)
        lblWeekday.font = UIFont.systemFont(ofSize: 8)
        lblMonth.font = UIFont.systemFont(ofSize: 8)
    }
    
    public func updateView(date: Date) {
        
        let weekday = calendarCurrent.component(.weekday, from: date) - 1
        
        let month = calendarCurrent.component(.month, from: date) - 1
        
        
        
        
        if(date.day == 1){
            lblMonth.text = dateFormatter.monthSymbols[month].uppercased()
        }else if(date.weekday == 2) {
            
            lblMonth.text = dateFormatter.monthSymbols[month].uppercased()
        }else{
            lblMonth.text = " "
        }
        
        lblDay.text = String(calendarCurrent.component(.day, from: date))
        lblWeekday.text = dateFormatter.shortWeekdaySymbols[weekday].uppercased()
        
        if date.isToday {
            lblDay.textColor = JZWeekViewColors.today
            lblWeekday.textColor = JZWeekViewColors.today
            lblMonth.textColor = JZWeekViewColors.today
        } else {
            lblDay.textColor = JZWeekViewColors.columnHeaderDay
            lblWeekday.textColor = JZWeekViewColors.columnHeaderDay
            lblMonth.textColor = JZWeekViewColors.columnHeaderDay
        }
    }
    
}
