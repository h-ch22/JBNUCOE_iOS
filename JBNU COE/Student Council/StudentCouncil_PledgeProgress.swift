//
//  StudentCouncil_PledgeProgress.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/20.
//

import SwiftUI
import FirebaseFirestore

struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(self.progress / 100.0))
                .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.red)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            
            Text(String(format: "%.0f %%", self.progress))
                .bold()
        }.onAppear(perform: {
            print(progress)
        })
    }
}

struct StudentCouncil_PledgeProgress: View {
    @State private var isSelected = "All"
    @State private var progressValue : Float = 0.0
    @State private var pledgeList : [String] = []
    @State private var implementedCnt : Float = 0.0
    @State private var pledges : [Pledge] = []
    @State private var communicationList : [String] = []
    @State private var communications : [Pledge] = []
    @State private var cultureList : [String] = []
    @State private var cultures : [Pledge] = []
    @State private var welfareList : [String] = []
    @State private var welfares : [Pledge] = []
    @State private var learningList : [String] = []
    @State private var learnings : [Pledge] = []
    @State var searchText = ""

    func getPledgeList(){
        implementedCnt = 0.0
        db = Firestore.firestore()
        let docRef = db.collection("Pledge")
        let pledgeRef = db.collection("Pledge").document(isSelected)

        if isSelected == "All"{
            docRef.getDocuments(){(querySnapshot, err) in
                if let err = err{
                    print(err)
                }
                
                else{
                    for document in querySnapshot!.documents{
                        var pledgeList : [String] = []
                        
                        self.pledgeList.append(contentsOf: Array(document.data().keys))
                        
                        print("document key : ", document.data().keys);
                        print(document.documentID , "->", document.data())
                        pledgeList.append(contentsOf: document.data().keys)
                        print("value : ", document.data().values)
                                          
                        if document.documentID == "Communication"{
                            communicationList.append(contentsOf : document.data().keys)
                        }
                        
                        if document.documentID == "Welfare"{
                            welfareList.append(contentsOf : document.data().keys)
                        }
                        
                        if document.documentID == "Learning"{
                            learningList.append(contentsOf : document.data().keys)
                        }
                        
                        if document.documentID == "Culture"{
                            cultureList.append(contentsOf : document.data().keys)
                        }
                        
                        for i in 0..<pledgeList.count{
                            self.loadImplements(Pledge: pledgeList[i], category: document.documentID)
                        }
                    }
                }
            }
        }
        
        if isSelected == "Communication"{
            for i in 0..<communicationList.count{
                self.loadImplements(Pledge: communicationList[i], category: "Communication")
            }
        }
        
        if isSelected == "Culture"{
            for i in 0..<cultureList.count{
                self.loadImplements(Pledge: cultureList[i], category: "Culture")
            }
        }
        
        if isSelected == "Learning"{
            for i in 0..<learningList.count{
                self.loadImplements(Pledge: learningList[i], category: "Learning")
            }
        }
        
        if isSelected == "Welfare"{
            for i in 0..<welfareList.count{
                self.loadImplements(Pledge: welfareList[i], category: "Welfare")
            }
        }
    }
    
    func loadImplements(Pledge : String, category: String){
        print(Pledge + "," + category)
        var implementsDictionary: Any?
        
        db = Firestore.firestore()
        
        let docRef = db.collection("Pledge").document(category)
        
        docRef.getDocument(){(document, error) in
            if let document = document{
                let implements_db = document.data()?[Pledge] as? String ?? "준비 중입니다."
                implementsDictionary = document.data()?[Pledge] as! [String : Any]
                
                let s = String(describing: implementsDictionary)

                var split_Str = s.components(separatedBy: "Optional([\"implemented\":")
                var final_Str = split_Str[1].components(separatedBy: "])")
                
                setProgress(setPledge: Pledge, implemented: final_Str[0])
            }
        }
    }
    
    func setProgress(setPledge : String, implemented : String){

        var implement = ""

        if implemented.contains("1"){
            implementedCnt += 1.0
            implement = "이행 완료"
        }
        
        else{
            implement = "준비 중"
        }
        
        if isSelected == "All"{
            if !pledges.contains(where: {($0.pledge == setPledge)}){
                pledges.append(Pledge(pledge: setPledge, implemented: implement))
            }
            
            if pledges.count == 37{
                progressValue = implementedCnt / Float(37) * 100
            }
            
        }
        
        if isSelected == "Communication"{
            if !communications.contains(where: {($0.pledge == setPledge)}){
                communications.append(Pledge(pledge: setPledge, implemented: implement))
            }
            
            if communications.count == 8{
                progressValue = implementedCnt / Float(8) * 100

            }
        }
        
        if isSelected == "Welfare"{
            
            if !welfares.contains(where: {($0.pledge == setPledge)}){
                welfares.append(Pledge(pledge: setPledge, implemented: implement))
            }
            
            
            if welfares.count == 13{
                progressValue = implementedCnt / Float(13) * 100

            }

        }
        
        if isSelected == "Learning"{
            
            if !learnings.contains(where: {($0.pledge == setPledge)}){
                learnings.append(Pledge(pledge: setPledge, implemented: implement))
            }
            
            if learnings.count == 8{
                progressValue = implementedCnt / Float(8) * 100

            }

        }
        
        if isSelected == "Culture"{
            
            if !cultures.contains(where: {($0.pledge == setPledge)}){
                cultures.append(Pledge(pledge: setPledge, implemented: implement))
            }
            
            if cultures.count == 8{
                progressValue = implementedCnt / Float(8) * 100

            }

        }
    }
    
    var body: some View {
        VStack{
            ProgressBar(progress : self.$progressValue)
                .frame(width : 150, height : 150)
                .padding(40)
            
            SearchBar(text : $searchText , placeholder: "공약 검색".localized())
            
            Spacer()
            
            ScrollView(.horizontal){
                HStack {
                        Button(action : {
                            isSelected = "All"
                            getPledgeList()
                        }){
                            Text("전체").foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.red))
                        
                        Button(action : {
                            isSelected = "Welfare"
                            getPledgeList()
                        }){
                            Text("복지").foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.pink))
                        
                        Button(action : {
                            isSelected = "Culture"
                            getPledgeList()
                        }){
                            Text("문화 / 예술").foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.orange))
                        
                        Button(action : {
                            isSelected = "Communication"
                            getPledgeList()
                        }){
                            Text("소통").foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.yellow))
                        
                        Button(action : {
                            isSelected = "Learning"
                            getPledgeList()
                        }){
                            Text("취업 / 학습").foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.green))
                }
            }.padding([.horizontal], 10)
            .padding([.vertical], 20)
            
            Spacer()
            
            if isSelected == "All"{
                List{
                    ForEach(pledges.filter{
                        self.searchText.isEmpty ? true : $0.pledge.lowercased().contains(self.searchText.lowercased())
                    }, id: \.self){ index in
                        PledgeRow(pledge: index)
                    }
                }
            }
            
            if isSelected == "Communication"{
                List{
                    ForEach(communications.filter{
                        self.searchText.isEmpty ? true : $0.pledge.lowercased().contains(self.searchText.lowercased())
                    }, id: \.self){ index in
                        PledgeRow(pledge: index)
                    }
                }
            }
            
            if isSelected == "Culture"{
                List{
                    ForEach(cultures.filter{
                        self.searchText.isEmpty ? true : $0.pledge.lowercased().contains(self.searchText.lowercased())
                    }, id: \.self){ index in
                        PledgeRow(pledge: index)
                    }
                }
            }
            
            if isSelected == "Welfare"{
                List{
                    ForEach(welfares.filter{
                        self.searchText.isEmpty ? true : $0.pledge.lowercased().contains(self.searchText.lowercased())
                    }, id: \.self){ index in
                        PledgeRow(pledge: index)
                    }
                }
            }
            
            if isSelected == "Learning"{
                List{
                    ForEach(learnings.filter{
                        self.searchText.isEmpty ? true : $0.pledge.lowercased().contains(self.searchText.lowercased())
                    }, id: \.self){ index in
                        PledgeRow(pledge: index)
                    }
                }
            }
            
        }.navigationBarTitle("실시간 공약 이행률")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            getPledgeList()
        })
    }
}

struct StudentCouncil_PledgeProgress_Previews: PreviewProvider {
    static var previews: some View {
        StudentCouncil_PledgeProgress()
    }
}
