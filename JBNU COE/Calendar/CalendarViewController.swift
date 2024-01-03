 //
//  CalendarViewController.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/11.
//

import Foundation
import KVKCalendar
import EventKit
import FirebaseStorage

final class CalendarViewController : UIViewController{
    private var events = [Event]()
    private var selectDate: Date = {
          let formatter = DateFormatter()
          let now = Date()
          formatter.dateFormat = "yyyy.MM.dd"
          formatter.locale = Locale(identifier: "ko_KR")
        
          var nowString = formatter.string(from: now)
          return formatter.date(from: nowString) ?? Date()
      }()
    
    private lazy var todayButton: UIBarButtonItem = {
            let button = UIBarButtonItem(title: "오늘", style: .done, target: self, action: #selector(today))
            button.tintColor = .systemRed
            return button
        }()
    
    private var style: Style = {
            var style = Style()
            if UIDevice.current.userInterfaceIdiom == .phone {
                style.timeline.widthTime = 40
                style.timeline.currentLineHourWidth = 45
                style.timeline.offsetTimeX = 2
                style.timeline.offsetLineLeft = 2
                style.headerScroll.titleDateAlignment = .center
                style.headerScroll.isAnimateTitleDate = true
                style.headerScroll.heightHeaderWeek = 70
                style.event.isEnableVisualSelect = false
                style.month.isHiddenTitle = true
                style.month.weekDayAlignment = .center
            } else {
                style.timeline.widthEventViewer = 350
                style.headerScroll.fontNameDay = .systemFont(ofSize: 17)
            }
            style.timeline.offsetTimeY = 25
            style.startWeekDay = .sunday
            style.timeSystem = TimeHourSystem.current ?? .twelve

            return style
        }()
    
    private lazy var calendarView: CalendarView = {
        let calendar = CalendarView(frame: CGRect(x: 0, y: view.frame.origin.y + 20, width: view.frame.width, height: view.frame.height - 150), date: selectDate, style: style)
            calendar.delegate = self
            calendar.dataSource = self
            return calendar
        }()
    
    public lazy var segmentedControl: UISegmentedControl = {
            let array = CalendarType.allCases
            let control = UISegmentedControl(items: array.map({ $0.rawValue.capitalized }))
            control.tintColor = .systemRed
            control.selectedSegmentIndex = 0
            control.addTarget(self, action: #selector(switchCalendar), for: .valueChanged)
            return control
        }()
    
    private lazy var eventViewer: EventViewer = {
            let view = EventViewer()
            return view
        }()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            if #available(iOS 13.0, *) {
                view.backgroundColor = .systemBackground
            } else {
                view.backgroundColor = .white
            }

            view.addSubview(calendarView)
            view.addSubview(segmentedControl)

            loadEvents { (events) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                    self?.events = events
                    self?.calendarView.reloadData()
                }
            }
        }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            var frame = view.frame
        frame.origin.y = view.frame.origin.y + 20
            calendarView.reloadFrame(frame)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @objc private func today() {
            selectDate = Date()
            calendarView.scrollTo(selectDate)
            calendarView.reloadData()
        }
        
        @objc private func switchCalendar(sender: UISegmentedControl) {
            let type = CalendarType.allCases[sender.selectedSegmentIndex]
            calendarView.set(type: type, date: selectDate)
            calendarView.reloadData()
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            loadEvents { [weak self] (events) in
                self?.events = events
                self?.calendarView.reloadData()
            }
        }
}

extension CalendarViewController: CalendarDelegate {
    func didChangeEvent(_ event: Event, start: Date?, end: Date?) {
        var eventTemp = event
        guard let startTemp = start, let endTemp = end else { return }
        
        let startTime = timeFormatter(date: startTemp)
        let endTime = timeFormatter(date: endTemp)
        eventTemp.start = startTemp
        eventTemp.end = endTemp
        eventTemp.text = "\(startTime) - \(endTime)\n new time"
        eventTemp.textForList = "\(startTime) - \(endTime)\n new time"
        eventTemp.textForMonth = "\(startTime) - \(endTime)\n new time"
        
        if let idx = events.firstIndex(where: { $0.compare(eventTemp) }) {
            events.remove(at: idx)
            events.append(eventTemp)
            calendarView.reloadData()
        }
    }
    
    func didSelectDates(_ dates: [Date], type: CalendarType, frame: CGRect?) {
        selectDate = dates.first ?? Date()
        calendarView.reloadData()
    }
    
    func didSelectEvent(_ event: Event, type: CalendarType, frame: CGRect?) {
        print(type, event)
        switch type {
        case .day:
            eventViewer.text = event.text
        default:
            break
        }
    }
    
    func didDeselectEvent(_ event: Event, animated: Bool) {
        print(event)
    }
    
    func didSelectMore(_ date: Date, frame: CGRect?) {
        print(date)
    }
    
    func didChangeViewerFrame(_ frame: CGRect) {
        eventViewer.reloadFrame(frame: frame)
    }
    
    func didAddNewEvent(_ event: Event, _ date: Date?) {
        var newEvent = event
        
        guard let start = date, let end = Calendar.current.date(byAdding: .minute, value: 30, to: start) else { return }

        let startTime = timeFormatter(date: start)
        let endTime = timeFormatter(date: end)
        newEvent.start = start
        newEvent.end = end
        newEvent.ID = "\(events.count + 1)"
        newEvent.text = "\(startTime) - \(endTime)\n new event"
        newEvent.textForList = "\(startTime) - \(endTime)\n new time"
        newEvent.textForMonth = "\(startTime) - \(endTime)\n new time"
        events.append(newEvent)
        calendarView.reloadData()
    }
}

extension CalendarViewController: CalendarDataSource {
    func eventsForCalendar(systemEvents: [EKEvent]) -> [Event] {
        // if you want to get a system events, you need to set style.systemCalendars = ["test"]
        let mappedEvents = systemEvents.compactMap { (event) -> Event in
            let startTime = timeFormatter(date: event.startDate)
            let endTime = timeFormatter(date: event.endDate)
            
            return event.transform(text: "\(startTime) - \(endTime)\n\(event.title ?? "")")
        }
        
        return events + mappedEvents
    }
    

    
    func willDisplayEventViewer(date: Date, frame: CGRect) -> UIView? {
        eventViewer.frame = frame
        return eventViewer
    }
}

extension CalendarViewController {
    func loadEvents(completion: @escaping ([Event]) -> Void) {
        let decoder = JSONDecoder()
        
        let storage = Storage.storage()
        let jsonRef = storage.reference(withPath: "calendar/events.json")
        let destinationPath : URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let destinationURL = destinationPath.appendingPathComponent("events.json")
        
        let downloadTask = jsonRef.write(toFile: destinationURL){url, error in
            if let error = error{
                print("error while downloading file : ", error)
                
                return
            }
            
            else{
                print("file download successful : ", url)
                
                let url_original = url?.absoluteString
                var url_arr = url_original?.components(separatedBy: "Optional(")
                var url_fin = url_arr![0].components(separatedBy: ")")
                
                if let dir : URL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false){
                    let path : String = URL(fileURLWithPath: dir.absoluteString).appendingPathComponent("events.json").path
                    guard let data = try? Data(contentsOf: URL(fileURLWithPath: path as! String), options: .mappedIfSafe) else{return}
                    let result = try? decoder.decode(ItemData.self, from: data)
                    
                    print("pass")
                    let events = result?.data.compactMap({ (item) -> Event in
                        let startDate = self.formatter(date: item.start)
                        let endDate = self.formatter(date: item.end)
                        let startTime = self.timeFormatter(date: startDate)
                        let endTime = self.timeFormatter(date: endDate)
                        
                        var event = Event(ID: item.id)
                        event.start = startDate
                        event.end = endDate
                        event.color = Event.Color(item.color)
                        event.isAllDay = item.allDay
                        event.isContainsFile = !item.files.isEmpty
                        event.textForMonth = "\(item.title) \(startTime)"
                        
                        if item.allDay {
                            event.text = " \(item.title)"
                            event.textForList = item.title
                        } else {
                            event.text = "\(startTime) - \(endTime)\n\(item.title)"
                            event.textForList = "\(startTime) - \(endTime)   \(item.title)"
                        }
                        
                        return event
                    })
                    completion(events!)
                }
            }
        }
    }
    
    func timeFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = style.timeSystem.format
        return formatter.string(from: date)
    }
    
    func formatter(date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: date) ?? Date()
    }
}

extension CalendarViewController: UIPopoverPresentationControllerDelegate { }

struct ItemData: Decodable {
    let data: [Item]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([Item].self, forKey: CodingKeys.data)
    }
}

struct Item: Decodable {
    let id: String, title: String, start: String, end: String
    let color: UIColor, colorText: UIColor
    let files: [String]
    let allDay: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, title, start, end, color, files
        case colorText = "text_color"
        case allDay = "all_day"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: CodingKeys.id)
        title = try container.decode(String.self, forKey: CodingKeys.title)
        start = try container.decode(String.self, forKey: CodingKeys.start)
        end = try container.decode(String.self, forKey: CodingKeys.end)
        allDay = try container.decode(Int.self, forKey: CodingKeys.allDay) != 0
        files = try container.decode([String].self, forKey: CodingKeys.files)
        let strColor = try container.decode(String.self, forKey: CodingKeys.color)
        color = UIColor.hexStringToColor(hex: strColor)
        let strColorText = try container.decode(String.self, forKey: CodingKeys.colorText)
        colorText = UIColor.hexStringToColor(hex: strColorText)
    }
}

extension UIColor {
    static func hexStringToColor(hex: String) -> UIColor {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return .gray
        }
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: 1.0)
    }
}

//final class CustomViewEvent: EventViewGeneral {
//    override init(style: Style, event: Event, frame: CGRect) {
//        super.init(style: style, event: event, frame: frame)
//
//        let imageView = UIImageView(image: UIImage(named: "ic_stub"))
//        imageView.frame = CGRect(origin: CGPoint(x: 3, y: 1), size: CGSize(width: frame.width - 6, height: frame.height - 2))
//        imageView.contentMode = .scaleAspectFit
//        addSubview(imageView)
//        backgroundColor = event.backgroundColor
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
