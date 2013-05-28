from sys import argv
import pickle 

#data structure is ['101020300', (learning, work, play, yes/no, short diary string), (day 2), (day 3) ...]
#sort of a cross between a diary / self-improvement log that looks at time spent in the past to check for 
#levels of scale. Sort of a sophisticated version of "all things in moderation" with inspiration from CA's
# Nature of Order textbooks

#breaks with bad input, needs 7 days of data before use

pkl = open('bisu.pkl', 'rb')
data = pickle.load(pkl)

def mode(choice=argv[1]):
	'''choose according to the cli flag provided'''
	
	if choice == "-r": 
		report()
	elif choice == "-w": 
		write()
	elif choice == "-p": 
		picture(choice)
	elif choice == "-d": 
		picture(choice)
	else:
		print "\nOops, let's try that again...\n\n---------\n"
		mode(raw_input("> ")) 

def report():
	'''Formulates a formatted string that depends on the proportions of time spent in days past and what day it is'''
	
	most, little, least = what_do()
	activity = fitness()
	day = len(data)
	if day % 76 == 0:
		print '\nFull Day Feast'
	elif day % 21 == 0:
		print "\nPartial Feast"
	print "\nMost: %s\nLittle: %s\nLeast: %s\nMove: %s\n" % (most, little, least, activity)

def what_do():
	'''returns ranking of action for the day: 
			play : work+learn is 1 : 4
			learn : work is 2 : 3'''
	
	work = ' - '
	learn = ' - LYaH / ?'
	play = ' - Play'
	learn_hrs = float(sum([data[i][0] for i in range(-7, 0)]))
	work_hrs = float(sum([data[i][1] for i in range(-7, 0)]))
	non_play = learn_hrs + work_hrs
	play_hrs = float(sum([data[i][2] for i in range(-7, 0)]))

	if play_hrs / non_play >= 0.25:          #too much play
		if learn_hrs / work_hrs >= 0.66:	 #not enough work 
			return work, learn, play
		else:
			return learn, work, play
	else:
		if learn_hrs / work_hrs >= 0.66:
			return play, work, learn
		else:
			return play, learn, work

def fitness():
	'''returns place in the fitness sequence'''
	
	key = {'0' : '  - Yoga', '1' : '  - Run and lift', '2' : '  - Run', '3' : '  - Climb'}
	return key[data[0][0]]

def write():
	'''gathers values then extends the list, handles the fitness seqence'''
	
	global data
	learn = int(raw_input('Learn: '))
	work = int(raw_input('Work: '))
	play = int(raw_input('Play: '))
	
	lift = raw_input('Lift? ')
	if lift == "yes":
		head, tail = data[0][0], data[0][1:]
		data[0] = "%s%s" % (tail, head) 

	honor = raw_input('Honor? ')
	diary = raw_input('and? ')
	
	check = raw_input("\nDoes this look good?\t (%d, %d, %d, '%s', '%s')" % (learn, work, play, honor, diary))
	if check == "no":
		return write()
	
	data.append((learn, work, play, honor, dear_diary))
	output = open('bisu.pkl', 'wb')
	pickle.dump(data, output)
	output.close()
	print "\n\nDone. Now think~!"

def picture(which):
	''' "-p" concats and prints, "-d" diary strings'''
	
	print "\n" * 120
	if which is "-p":
		print ''.join(e[-2] for e in data[1:])
	else:
		for e in data[1:]:
			print e[-1]	
	print "\n" * 4

mode()
pkl.close()