bisu
====

planning/diary/motivation app, named after broodwar pro bisu. 

It's used to keep proportion between work/learning/play going back seven days (easily adjustable)---the levels of scale idea is taken from the Christopher Alexander's Nature of Order textbooks. 

It also keeps track for periodic fasting and is a database for diary entries. The grade values are based on Seinfeld's "Don't break the chain."

Not using a date-entry key-value structure is on purpose. Further comments are in the file.

It runs in a terminal and is meant to run indefinitely (looking forward to designing a simple gui once library support is more solid). Tracking of time is simplistic in that passage of time is tracked by number of entries.  

It requires a well-formed file to read from---at least seven days of entries.

sequence.txt = "101020300"
data.txt = [(learning, work, play, O/X, short diary string), (day 2), (day 3) ...]