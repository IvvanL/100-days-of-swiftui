# Day 42 - Moonshot Project 8, part 4 - Challenge

- Challenge parameters:

- 1. Add the launch date to MissionView, below the mission badge. You might choose to format this differently given that more space is available, but it’s down to you.
- 2. Extract one or two pieces of view code into their own new SwiftUI views – the horizontal scroll view in MissionView is a great candidate, but if you followed my styling then you could also move the Rectangle dividers out too.
- 3. For a tough challenge, add a toolbar item to ContentView that toggles between showing missions as a grid and as a list.

- See day 43 project code for internal notes and finalized code.

CHALLENGE #1: on MissionView.swift, added launch date below the badge

        ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { width, axis in
                        width * 0.6
                    }
                
                
                VStack(alignment: .leading) {
                    
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(.lightBackground)
                        .padding(.vertical)
                    
                    Text("Launch Date: \(mission.formattedLaunchDate)")
                    // challenge 1: added launch date below badge
                        .font(Font.body.bold())
                        .frame(maxWidth: .infinity, alignment: .center)

CHALLENGE #2:  Part 1 - created a SectionDivider view. Since it is repeated multiple times. It will be something to easily manage future updates without going in manually to each view specifically and changing it. and it also creates more clean code.

import SwiftUI

struct SectionDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.lightBackground)
            .padding(.vertical)
    }
}
    
#Preview {
    SectionDivider()
}
 
CHALLENGE #2: Part 2 - 
    1. Extracted the crew horizontal scroll view into its own CrewScrollView, moved CrewMember to its own top-level model file so both views could share it, and wired everything back together

CrewMember view:

import Foundation

struct CrewMember {
    let role: String
    let astronaut: Astronaut
}
 
CrewScrollView:

import SwiftUI

struct CrewScrollView: View {
    let crew: [CrewMember]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew, id: \.role) { crewMember in
                    NavigationLink {
                        AstronautView(astronaut: crewMember.astronaut)
                    } label: {
                        HStack {
                            Image(crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 104, height: 72)
                                .clipShape(.capsule)
                                .overlay(Capsule()
                                    .strokeBorder(.white, lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(crewMember.astronaut.name)
                                    .foregroundStyle(.white)
                                    .font(.headline)
                                
                                Text(crewMember.role)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}
#Preview {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    return CrewScrollView(crew: [CrewMember(role: "Some role", astronaut: astronauts["aldrin"]!)])
}

CHALLENGE #3: 
