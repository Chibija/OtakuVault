//
//  ContentView.swift
//  OtakuVault
//
//  Created by Michael Bosworth on 5/14/23.
//

import Foundation
import SwiftUI
import AuthenticationServices
import Combine
import RswiftResources

// MARK: - View
struct LoginView: View {
    @State var viewModel = LoginViewModel(dependencies: LoginDependencies())
    
    var body: some View {
        ZStack(alignment: .top) {
            // background
            Image(R.image.loginBg)
                .resizable()
                .scaledToFit()
            
            // options
            VStack {
                Spacer()
                ZStack {
                    Rectangle() //temp?
                        .foregroundColor(Color.black)
                        .frame(height: 300)
                        .blur(radius: 20)
                        .padding([.horizontal, .bottom], -60)
                    content
                }

            }
        }
        .ignoresSafeArea()
    }
    
    private var content: some View {
        VStack(spacing: 16) {
            title
            subtitle
            options
        }
//        .background(.red)
    }
    
    // MARK: - Title
    private var title: some View {
        HStack(alignment: .center) {
            Image(R.image.logoAndName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 200)
        }
        .foregroundColor(.orange)
    }
    
    // MARK: - Subtitle
    private var subtitle: some View {
        Text("All your favorite anime. All in the same place")
            .foregroundColor(.white)
    }
    
    // MARK: - Options
    private var options: some View {
        VStack(spacing: 8) {
            Button {
                viewModel.getCode()
            } label: {
                Text("Login")
            }
            .buttonStyle(PrimaryButtonStyle())
            
            Button {
                // show sign up webView
            } label: {
                Text("Sign Up")
            }
            .buttonStyle(SecondaryButtonStyle())
            
            Button {
                // push to home as guest
            } label: {
                Text("or ")
                    .foregroundColor(.white)
                Text("Continue as a Guest")
                    .foregroundColor(.orange)
            }
        }
        .padding(.bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
