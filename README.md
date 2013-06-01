bisu
====

planning app, named after the pro sc player Bisu.

Generally it has three branches:

The first one ("-r") looks at the past seven days, as well where the day is in the timeline, and sorts some strings of importance such that, should the program be followed, time spent will have levels of scale in the distribution. It also reads out from a fitness sequence.

The second one ("-p" and "-d") reads information out from the file and prints it accordingly. Currently the good/bad for the day, and the diary strings.

Lastly, it can write a new entry ("-w"). It does this by prompting for the values and then appending the file. This also tracks whether or not the fitness sequence moves forward or not, to allow for flexibility with training circumstances.


I first wrote it in Python, then Haskell. Note that there's little to no error handling; this was because so far I'm the only one using it and I'm very careful to give it well-formed input.

Haskell data:
--fit_sequence = "101020300"
--the_list = [(learning, work, play, yes/no, short diary string), (day 2), (day 3) ...]

Python:
['101020300', (learning, work, play, yes/no, short diary string), (day 2), (day 3) ...] 

Next step, a GUI with tabs for the different modes.