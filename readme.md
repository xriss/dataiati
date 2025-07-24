dataiati

A test git repo to see if we can use git to keep a history of all iati data, or if it takes up too much disk space.

An initial commit seems to be a git directory of 1.3 gig once git has compressed itsself.

Each activity is kept in its own file named iati-identifier.xml which lives inside a dataset directory (slug name from the registry) which is in turn kept in the xml directory.

The reason to keep each activity in its own file is we want the git history to be meaningful, in this case you can look at an individual activity.

All of these filesnames have to be sanitised with unsafe characters replaced with an _ but mostly they will be named as found in the xml data.


