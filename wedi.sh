#!/bin/sh

#/*
# *	@name: Project 1 for IOS
# *	@author: Matej Soroka <xsorok02>
# */

EDITOR="vim"

if [ $# -gt 0 ]; then # if we have some argiment

    if [ "$#" -lt 3 ]; then # if we have less than 3 arguments

        if [ "$1" = "-m" ]; then # if first argument is switch for most frequent file

            if [ "$#" -gt 1 ]; then
                echo "Opening most frequently opened file in folder $2"
            else
                echo "Opening most frequently opened file in current folder"
            fi

        elif [ "$1" = "-l" ]; then # if first argument is switch for listing files in directory

            if [ "$#" -gt 1 ]; then
                echo "Printing list in folder $2"
            else
                echo "Printing list of files in current folder"
                exec ls
            fi

        elif [ "$1" = "-b" -o "$1" = "-a" ]; then

            if [ "$#" -gt 1 ]; then
                echo "Printing list of files before | after ..."
            else
                echo "Date was not set"
            fi

        else
            echo $1\#`date +%s` >> WEDI_RC
            file="WEDI_RC"
            # .+?(?=#)
            #exec $EDITOR $1
        fi

    fi

else
    if [ -f "WEDI_RC" ]; then # if WEDI_RC exist
      echo 'Exist'
    else
      > WEDI_RC # create file
    fi
fi
