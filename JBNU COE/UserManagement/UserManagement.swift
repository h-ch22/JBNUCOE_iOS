//
//  UserManagement.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/14.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

var db = Firestore.firestore()

class UserManagement : ObservableObject{
    @Published var isSignedIn : Bool = false
    @Published var isAdmin : Bool = false
    @Published var studentNo : String = ""
    @Published var mail : String = ""
    @Published var dept : String = ""
    @Published var spot : String = ""
    @Published var name : String = ""
    var password : String = ""
    var phone : String = ""
    
    func autoLogIn(mail : String, password : String){
        UserDefaults.standard.set(mail, forKey: "mail")
        UserDefaults.standard.set(password, forKey: "password")
    }
    
    func autoLogOut(){
        UserDefaults.standard.removeObject(forKey: "mail")
        UserDefaults.standard.removeObject(forKey: "password")
    }
    
    func signUp(mail : String, password : String, dept : String, studentNo : String, phone : String){
        
    }
    
    func temporarySaveInformation(mail : String, password : String, phone : String, name : String){
        self.mail = mail
        self.password = password
        self.phone = phone
        self.name = name
    }
    
    func getPhone(){
        let docRef = db.collection("User").document(mail)
        
        docRef.getDocument(){(document, error) in
            if let document = document{
                self.phone.append(document.get("phone") as! String)
                self.phone = document.get("phone") as! String
            }
        }
    }
    
    func getStudentNo(){
        let docRef = db.collection("User").document(mail)
        
        docRef.getDocument(){(document, error) in
            if let document = document{
                self.studentNo.append(document.get("studentNo") as! String)
                self.studentNo = document.get("studentNo") as! String
                
                if self.studentNo != "" && self.studentNo != nil{
                    self.getAdminInfo()
                }

            }
        }
    }
    
    func getAdminInfo(){
        let docRef = db.collection("User").document("Admin")
        
        if self.studentNo == ""{
            getStudentNo()
        }
        
        docRef.getDocument(){(document, error) in
            if let document = document, document.exists{
                if document.get(self.studentNo) != nil {
                    self.isAdmin = true
                    
                    self.spot = document.get(self.studentNo) as! String
                }
                
                else{
                    self.isAdmin = false
                }
            }
            
            else{
                self.isAdmin = false
            }
        }
    }
    
    func signIn(mail : String, password : String){
        Auth.auth().signIn(withEmail: mail, password: password){
            (user, error) in
            if user != nil{
                let docRef = db.collection("User").document(Auth.auth().currentUser?.email as! String)
                
                docRef.updateData(["token" : Messaging.messaging().fcmToken]){ err in
                    if let err = err{
                        print(err)
                    }
                    
                    else{
                        let ref = db.collection("User").document(Auth.auth().currentUser?.email as! String)
                        
                        ref.getDocument(){(result, err) in
                            if let err = err{
                                print(err)
                            }
                            
                            else{
                                let studentNo = result!.get("studentNo") as! String
                                
                                let adminRef = db.collection("User").document("Admin")
                                
                                adminRef.getDocument(){(document, err) in
                                    if let err = err{
                                        print(err)
                                    }
                                    
                                    else{
                                        if document!.get(studentNo) != nil{
                                            adminRef.collection("tokens").document(studentNo).setData(["token" :
                                                Messaging.messaging().fcmToken
                                            ])
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                self.isSignedIn = true
                self.mail.append(mail)
                self.mail = mail
                
                self.getName()
            }
            
            else{
                self.isSignedIn = false
            }
        }
    }
    
    func getName(){
        let docRef = db.collection("User").document(Auth.auth().currentUser?.email as! String)
        
        docRef.getDocument(){(document, error) in
            if let document = document{
                self.name = document.get("name") as! String
                
                if self.name != "" && self.name != nil{
                    self.getDept()
                }
            }
        }
    }
    
    func getEmail(){
        if Auth.auth().currentUser != nil{
            self.mail = (Auth.auth().currentUser?.email)!
            getName()
        }
    }
        
    func getDept(){
        let docRef = db.collection("User").document(mail)
        
        docRef.getDocument(){(document, error) in
            if let document = document{
                self.dept = document.get("dept") as! String
                
                if self.dept != "" && self.dept != nil{
                    self.getStudentNo()
                }
            }
        }
    }
}
