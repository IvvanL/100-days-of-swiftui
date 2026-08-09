# Day 41 - Moonshot Project 8, part 3

- completed Moonshot App byt adding two new views plus a navigationbetween them, along with custom layout techniques
- Used containerRelativeFrame() to size views relative to their container (e.g. making an image take up a set proportion of screen width) for precise custom layouts
- Combined with ScrollView to lay out mission detail content that adapts nicely to different screen sizes
- Tackled a common real-world problem: combining two separate pieces of data that need to relate to each other — in this case, astronaut data and mission data (crew roles)
- Learned how to decode two separate JSON structs and merge/cross-reference them (e.g. matching astronaut IDs to crew roles per mission) rather than forcing everything into one bloated struct
- Built a third view, AstronautView, to show astronaut details when tapping an astronaut in MissionView — completing a 3-level navigation hierarchy (missions → mission detail → astronaut detail)
- Used the same ScrollView + VStack pattern: image (resizable, scaled to fit) + description text
- Updated #Preview to load astronauts.json and pass a sample astronaut
- Connected via NavigationLink in MissionView
- Key takeaway: NavigationStack automatically handles slide-in transitions, back buttons, and swipe-to-go-back, reinforcing the drill-down feel of the app
