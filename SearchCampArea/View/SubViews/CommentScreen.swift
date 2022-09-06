//
//  CommentScreen.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 28.06.2022.
//

import SwiftUI

struct CommentScreen: View {
    @ObservedObject var campingManager : CampingAreaManager
    var user : User
    @State var commentText = ""
    
    var body: some View {
        VStack{
            if campingManager.comments.count > 0 {
                ScrollView{
                    VStack{
                        ForEach(campingManager.comments){cmt in
                            CommentView(comment: cmt.comment, date: cmt.commentDate.formatted(date: .numeric, time: .omitted), user: cmt.userId )
                        }
                    }
                }
            } else {
                Text("No comment found")
            }
            Spacer()
            VStack{
                TextField("Comment", text: $commentText)
                    .lineLimit(5)
                    .lineSpacing(20)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.leading)
                
                Button {
                    campingManager.AddAreaComment(campid: campingManager.selectedArea.id, userid: user.email, comment: commentText)
                } label: {
                    Text("Share Comment")
                        .padding()
                }

            }
            
        }
        .onAppear(){
            campingManager.GetAreaComments(id: campingManager.selectedArea.id)
            commentText = ""
        }
    }
}

struct CommentScreen_Previews: PreviewProvider {
    static var previews: some View {
        CommentScreen(campingManager: CampingAreaManager() , user : User(name: "", surname: "", email: "", profilepic: ""))
    }
}


