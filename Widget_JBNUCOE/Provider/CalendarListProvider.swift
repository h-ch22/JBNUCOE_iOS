//
//  CalendarListProvider.swift
//  Widget_JBNUCOEExtension
//
//  Created by 하창진 on 2021/07/07.
//

import Foundation
import WidgetKit
import FirebaseStorage
import EventKit

struct CalendarProvider : TimelineProvider{
    typealias Entry = CalendarListEntry
    let formatter = DateFormatter()
    let entry = CalendarListEntry(date: Date(), model : [CalendarModel(title: "start", start: "start")])
    
    func placeholder(in context: Context) -> CalendarListEntry {
        entry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CalendarListEntry) -> Void) {
        let event_1 = CalendarModel(title: "하기 휴가 시작", start: "2021. 06. 18.")
        let event_2 = CalendarModel(title: "하기 계절 수업 시작", start: "2021. 06. 21.")
        let event_3 = CalendarModel(title: "하기 계절 수업 종료", start: "2021. 07. 16.")
        let event_4 = CalendarModel(title: "하기 특별 학기 시작", start: "2021. 07. 19.")
        let event_5 = CalendarModel(title: "하기 특별 학기 종료", start: "2021. 08. 20.")
        let event_6 = CalendarModel(title: "제 1학기 종료", start: "2021. 08. 20.")
        let event_7 = CalendarModel(title: "하기 휴가 종료", start: "2021. 08. 31.")


        let entry = CalendarListEntry(model: [event_1, event_2, event_3, event_4, event_5, event_6, event_7])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CalendarListEntry>) -> Void) {
        let decoder = JSONDecoder()
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 12, to: currentDate)!
        let storage = Storage.storage()
        let jsonRef = storage.reference(withPath: "calendar/events.json")
        let destinationPath : URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let destinationURL = destinationPath.appendingPathComponent("events.json")
        var model : [CalendarModel] = []

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
                    
                    do{
                        let result = try decoder.decode(calendarData.self, from: data)
                        

                        let events = result.data.compactMap({ item in
                            formatter.dateFormat = "yyyy. MM. dd."
                            let current_string = formatter.string(from: Date())
                            let current = formatter.date(from: current_string)
                            let date_split = item.start.components(separatedBy: "T")
                            print("split : ", date_split)
                            let start = formatter.date(from: date_split[0])
                                                        
                            print(start)
                            
                            if start! > current!{
                                model.append(CalendarModel(title: item.title, start: date_split[0]))
                            }
                            
                            model.sort{
                                $0.start < $1.start
                            }
                                                        
                            
                        })
                    } catch{
                        print(error)
                    }
                    
                }
                
                let entry = CalendarListEntry(date: currentDate, model : model)
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                
                completion(timeline)
            }
        }
    }
}
