#!/usr/bin/env python3



#  TEMPORARY CONTENTS




# Name: Update README
# Authors: David 
# Last Update: 02 FEB 2022
# Requirements: Python 3.8
# Run using: clear && python3 updateREADME.py
# Run in: SSF2Replays folder (or repo folder)


# Import modules
import os
import sys
import datetime



# Main function
def main(arguments):

    # Notify
    print("###### UPDATE README by David ######")

    # Get replay directories
    replayDirs = getReplayDirs()

    # Get new replay count/line
    newReplayLine = getNewReplayLine(replayDirs)

    # Notify
    print("\nGenerated new line: \n" + newReplayLine)

    # Update replay count in README file
    updateReplayCount(newReplayLine)

    # Notify
    print("\nSuccessfully wrote to README file")
    




# Get replay directories
def getReplayDirs():

    # Get directory that script is running in
    runPath = os.path.abspath(os.path.dirname(__file__))

    # Get file and folder paths there
    paths = [os.path.abspath(x) for x in os.listdir(runPath)]

    # Replay directories holder
    replayDirs = list()

    # For each file/folder path
    for curPath in paths:

        # Convert to string
        curPathS = str(curPath)

        # Check that path is not an un-needed path
        check1 = 'README' not in curPathS
        check2 = '.git' not in curPathS

        # If directory passes checks (i.e. it is needed)
        if(check1 and check2):

            # Add to replay directories list
            replayDirs.append(curPathS)

    # Return replay directories
    return replayDirs




# Get new replay count/line
def getNewReplayLine(replayDirs):

    ### Count replays

    # Replay count holder
    replayCount = 0

    # For each replay directory
    for replayPathS in replayDirs:

        # Iterate that directory
        for root, dirs, files in os.walk(replayPathS):

            # For each file found
            for file in files:

                    # If has replay extension
                    if file.endswith('.ssfrec'):

                            # Add to replay count
                            replayCount += 1

    ### Generate README line from replay count

    # Initialize string template/format string
    newReplayLine = "### Replay Count = NUM (as of DATE)"

    # Add replay count number
    newReplayLine = newReplayLine.replace("NUM", str(replayCount))

    # Get date string
    dateS = datetime.datetime.today().strftime('%d/%m/%y')

    # Add date
    newReplayLine = newReplayLine.replace("DATE", str(dateS))

    # Return new replay line
    return newReplayLine






# Update replay count in README file
def updateReplayCount(newReplayLine):

    # Open readme file for reading and writing
    readmeFile = open("README.md", "r+")

    # Get readme file lines
    readmeLines = readmeFile.readlines()
    
    ### Get replay line index

    # Replay line index holder
    replayLineIndex = 0

    # For each index
    for curIndex in range(len(readmeLines)):

        # Get line
        curLine = readmeLines[curIndex]

        # If this is replay line
        if "### Replay Count" in curLine:

            # Save index and stop
            replayLineIndex = curIndex
            break

    # Replace that line with new one
    readmeLines[replayLineIndex] = newReplayLine

    # Seek back to start of file (prevents appending/doubling up)
    readmeFile.seek(0)

    # Write the new lines
    for line in readmeLines:
        readmeFile.write(line)

    # Close readme file
    readmeFile.close()



# If file is run from the command line:
if __name__ == '__main__':

    # Run main function with arguments then exit
    sys.exit(main(sys.argv[1:]))