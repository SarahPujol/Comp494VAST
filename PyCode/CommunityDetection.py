import csv

locationToChar = {}
personIDToCharString = {}
idIndexList = []
squareMatrix = []

def processFile():
    stringChar = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*:()"
    currentIndex = 0
    with open('D:\COMP494\Comp494VAST\ParkMovement\data\park-movement-Fri-FIXED-2.0.csv', newline = '') as csvfile:
        reader = csv.reader(csvfile, delimiter = ',')
        for row in reader:
            if row[2] == "check-in":
                ID = row[1]
                location = row[3]

                if ID not in personIDToCharString:
                    personIDToCharString[ID] = ''
                if location in locationToChar:
                    charToPut = locationToChar[location]
                else:
                    charToPut = stringChar[currentIndex]
                    currentIndex =+1
                    locationToChar[location] = charToPut
                personIDToCharString[ID]  = personIDToCharString[ID] + charToPut
    for key in personIDToCharString:
        idIndexList.append(key)

def calculateAllEditDistance():
    for s1 in idIndexList:
        constructList=[]
        for s2 in idIndexList:
            editDistanceVal = levenshteinDistance(s1,s2)
            constructList.append(editDistanceVal)
        squareMatrix.append(constructList)

def levenshteinDistance(s1, s2):
    if len(s1) > len(s2):
        s1, s2 = s2, s1

    distances = range(len(s1) + 1)
    for i2, c2 in enumerate(s2):
        distances_ = [i2+1]
        for i1, c1 in enumerate(s1):
            if c1 == c2:
                distances_.append(distances[i1])
            else:
                distances_.append(1 + min((distances[i1], distances[i1 + 1], distances_[-1])))
        distances = distances_
    return distances[-1]

def writeOutput():
    with open('output.csv','w', newline= '') as f:
        writer = csv.writer(f)
        writer.writerow(idIndexList)
        counter = 0
        for rows in squareMatrix:
            writer.writerow([idIndexList[counter]] + rows)
            counter +=1
processFile()
calculateAllEditDistance()
writeOutput()