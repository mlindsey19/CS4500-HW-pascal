##
##Mitch Lindsey
##3/11/19
##cs4500

##this program will take an file with integers arranged to repespent
##circles and arrows pointing to the circls, This would create a map
##and the program randomly tranverses these arrows until each one has
##been seen. the program prints and creates a file with the sum of all 
##visits, the avg number of visits and max visits
##The main data stucture is an array of or record Arrow.
##Record Arrow is two interger values that represent the exit and 
##entry points of two circles. 
##The ciricles are represnted by an array of integters. This array is 
##incremented at the circles index when it is visited. The current circle
##is accounted for with a single integer cooresponding to the index in the
##array.
##To randomized the arrow selection out of a circle, a random arrow is 
##chosen from the array of ALL arrows and compared to the current circle
##variable. If the arrow source == current circle, curent circle is set
##to the arrow destination and circle array is incremented. if the source 
##of arrow does not match, another one is chosen until there is a match.


import random
import turtle as t

arrowList = []
visitCounts = []
visualsList = []

file = input("enter file name: ")

with open(file) as f:
    N = int(f.readline())
    k =  int(f.readline())
    for i in range(k):
        str = f.readline()
        arrowList.append( (int( str[0] ) - 1, int( str[2] ) - 1) )

currentCircle = 0
circlesSeen = 1
for i in range(N):
    visitCounts.append(0)
visitCounts[0] = 1

while circlesSeen < N:
    thisArrow = random.choice(arrowList)
    if thisArrow[0] == currentCircle:
        currentCircle = thisArrow[1]
        if visitCounts[currentCircle] == 0:
            circlesSeen += 1
        visitCounts[currentCircle] += 1

        visualsList.append(thisArrow)


angle = 360 / N
for i in range(N):
    t.penup()
    t.goto(0,0)
    t.setheading(0)
    t.left(angle * i)
    t.forward(35 * N)
    t.pendown()
    t.circle(50)

colorlist = [1]
for i in range(1,N):
    colorlist.append(0)

t.colormode(255)
t.penup()
t.goto(0,0)
t.setheading(0)
t.forward(35 * N)
t.pendown()
t.fillcolor(0,255,255)
t.begin_fill()
t.circle(50)
t.end_fill()
for arrow in visualsList:
    t.goto(0,0)
    t.setheading(0)
    t.left(angle * arrow[1])
    t.forward(35 * N)
    x = 16 * colorlist[arrow[1]]
    gcolor = x if x < 255 else 255
    t.fillcolor(0,255 - gcolor ,255)
    t.begin_fill()
    t.circle(50)
    t.end_fill()
    colorlist[arrow[1]] += 1

print("arrows:",k)
print("circles:",N)
print("sum:", sum(visitCounts))
print("avg:", sum(visitCounts)/N)
print("max:", max(visitCounts))


z = input()

    
    











        
