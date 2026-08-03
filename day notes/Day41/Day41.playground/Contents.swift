// ** DAY 41 PROJECT 8, Part 3 **

// ** SHOWING MISDSION DETAILS WITH SCROLLVIEW AND CONTAINERRELATIVEFRAME() **
 
/*
 
 Goal: Build MissionView.swift to show mission details (badge, description) when a user taps a mission from the list. Crew details will be added later since they require cross-referencing two JSON files.
 
 Layout structure:
    - ScrollView containing a VStack
    - Resizable mission badge image, sized with containerRelativeFrame(.horizontal) at 60% width (50–70% avoids the image looking oversized)
    - Nested VStack(alignment: .leading) for the "Mission Highlights" title + description text
    - Nesting a leading-aligned VStack inside the outer centered VStack lets you mix alignments in one view (image centered, text leading-aligned)
 
 Key code:
 
 struct MissionView: View {
     let mission: Mission

     var body: some View {
         ScrollView {
             VStack {
                 Image(mission.image)
                     .resizable()
                     .scaledToFit()
                     .containerRelativeFrame(.horizontal) { width, axis in
                         width * 0.6
                     }
                     .padding(.top)

                 VStack(alignment: .leading) {
                     Text("Mission Highlights")
                         .font(.title.bold())
                         .padding(.bottom, 5)

                     Text(mission.description)
                 }
                 .padding(.horizontal)
             }
             .padding(.bottom)
         }
         .navigationTitle(mission.displayName)
         .navigationBarTitleDisplayMode(.inline)
         .background(.darkBackground)
     }
 }
 
 Preview fix: Since MissionView needs a Mission object, the preview must decode one from JSON using the Bundle extension:
 
 #Preview {
     let missions: [Mission] = Bundle.main.decode("missions.json")
     return MissionView(mission: missions[0])
         .preferredColorScheme(.dark)
 }

 Tip: The dark color scheme normally comes from NavigationStack in ContentView, but previews don't inherit that automatically — set .preferredColorScheme(.dark) manually in the preview.

 
*/

// ** MERGING CODABLE STRUCTS **

/*

 Goal: Show crew member pictures, names, and roles below the mission description — requires joining data from missions.json (which crew IDs + roles) and astronauts.json (astronaut details), since neither file has the full picture alone.
 
 1. Nested CrewMember struct
 
 Add inside MissionView:
 
 struct CrewMember {
     let role: String
     let astronaut: Astronaut
 }
 
 2. New crew property

 let crew: [CrewMember]
 
 Holds the resolved role/astronaut pairs.
 
 3. Custom initializer resolves the crew
 
 init(mission: Mission, astronauts: [String: Astronaut]) {
     self.mission = mission

     self.crew = mission.crew.map { member in
         if let astronaut = astronauts[member.name] {
             return CrewMember(role: member.role, astronaut: astronaut)
         } else {
             fatalError("Missing \(member.name)")
         }
     }
 }
 
 Loops over the mission's crew list, looks up each by ID in the astronauts dictionary.
 
 Why fatalError() here? A missing astronaut ID means broken/invalid JSON data — a bug in the data itself, not something to gracefully handle at runtime. Crash loudly instead of silently failing.
 
 4. Update the #Preview
 
 Needs both missions and astronauts decoded now:
 
 #Preview {
     let missions: [Mission] = Bundle.main.decode("missions.json")
     let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

     return MissionView(mission: missions[0], astronauts: astronauts)
         .preferredColorScheme(.dark)
 }
 
 5. Horizontal scroll view for crew
 
 Placed after the VStack(alignment: .leading) (not inside it):
 
 ScrollView(.horizontal, showsIndicators: false) {
     HStack {
         ForEach(crew, id: \.role) { crewMember in
             NavigationLink {
                 Text("Astronaut details")
             } label: {
                 HStack {
                     Image(crewMember.astronaut.id)
                         .resizable()
                         .frame(width: 104, height: 72)
                         .clipShape(.capsule)
                         .overlay(
                             Capsule()
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
 
 Why outside the VStack? Scroll views look best edge-to-edge. Putting it inside the padded VStack would clip crew members oddly against the leading edge.
 
 6. Update ContentView's NavigationLink
 
 Replace the placeholder destination with:
 
 MissionView(mission: mission, astronauts: astronauts)
 
 7. Optional custom dividers
 
 SwiftUI's built-in Divider() isn't customizable, so use a styled Rectangle instead — placed before "Mission Highlights" and again after mission.description:
 
 Rectangle()
     .frame(height: 2)
     .foregroundStyle(.lightBackground)
     .padding(.vertical)
 
 8. "Crew" section title
 
 Add inside the VStack, after the second rectangle, so it lines up with the same padding as the rest of the text:
 
 Text("Crew")
     .font(.title.bold())
     .padding(.bottom, 5)
*/

// ** FINISHING UP WITH ONE LAST VIEW **
