#!/bin/sh

export LC_ALL=POSIX

# if WEDI_RC is set
if [ -z "$WEDI_RC" ]; then
    echo "Destination to data file doesn't exist"
    exit 1
fi

# $1 -o|-p open or print file
# $2 absolute destination to file
handleDestination()
{
    FILES="$2"
    absolute="$3"

    for destination in $FILES
    do
        # dirname of destination is equal to absolute destination to folder and
        # absolute destianton to file is file
        if [ "$(dirname "$destination")" = "$absolute" ] && [ -f "$destination" ]; then
            if [ "$1" = "-p" ]; then
                basename "$destination" # print file from absolute destianton
            elif [ "$1" = "-o" ]; then
                openEditor "$destination"
                exit 0
            fi
        fi
    done
}

# $1 absolute destination to file
openEditor()
{
    if [ "$EDITOR" ]; then      # variable EDITOR is set
        "$EDITOR" "$1"          # opens file set by argument with editor from EDITOR variable
    elif [ "$VISUAL" ]; then    # variable VISUAL is set
        "VISUAL" "$1"           # opens file set by argument with editor from VISUAL variable
    else                        # if neither EDITOR or VISUAL isn't set, choose vi editor
        vi "$1"                 # opens file set by argument with vi editors
    fi

    echo "$1|$(date +%Y-%m-%d)" >> "$WEDI_RC" # write record
}

# $1 -b|-a before or after switch
# $2 date in YYYY-MM-DD format
# $3 absolute destination to directory
getFilesInDirectoryByDate()
{
    date="$2"

    if [ "$1" = "-b" ]; then        # if argument is -b

        FILES=$(awk -F\| -v argument="$date" 'argument > $2 {print $1}' "$WEDI_RC" | sort | uniq)

    elif [ "$1" = "-a" ]; then      # if argument is -a

        FILES=$(awk -F\| -v argument="$date" 'argument <= $2 {print $1}' "$WEDI_RC" | sort | uniq)

    else

        invalidArgument

    fi

    handleDestination "-p" "$FILES" "$3"
}

# $1 absolute destination to directory
getFilesInDirectory()
{
    FILES=$(awk -F\| '{print $1}' "$WEDI_RC" | sort | uniq) # get all unique lines
    handleDestination "-p" "$FILES" "$1"
}

# $1 absolute destination to directory
runLastFileInFolder()
{
    FILES=$(awk -F\| '{print $1}' "$WEDI_RC" | sort | uniq) # get all unique lines
    handleDestination "-o" "$FILES" "$1"
}

# $1 absolute destination to directory
getMostEditedFile()
{
    # cut line into destination and date by delimiter |, select destination,
    # sort it by name
    # filter unique values and count
    # sort by count
    # trim whitespace
    # cut line into count and destination by delimiter ' ', and select destination
    FILES=$(<"$WEDI_RC" cut -d'|' -f1 | sort -n | uniq -c | sort -r | awk '{$1=$1};1' | cut -d ' ' -f 2)
    handleDestination "-o" "$FILES" "$1"
}

invalidArgument()
{
    echo "Invalid argument"
    exit 9
}

if [ "$#" = "0" ]; then # run without argument => opens last edited file from folder

    runLastFileInFolder "$(realpath .)"

elif [ "$#" = "1" ]; then # if programs is triggered with one argument

    if [ -f "$1" ]; then                # if argument is file

        openEditor "$(realpath "$1")"

    elif [ -d "$1" ]; then              # if argument is folder

        runLastFileInFolder "$(realpath ./"$1")"

    elif [ "$1" = "-l" ]; then          # if argument is -l

        getFilesInDirectory "$(realpath .)"

    elif [ "$1" = "-m" ]; then          # if argument is -m

        getMostEditedFile "$(realpath .)"

    else

        invalidArgument

    fi

elif [ "$#" = "2" ]; then # if programs is triggered with two arguments

    if [ "$1" = "-l" ]; then          # if argument is -l

        if [ -d "$(realpath ./"$2")" ]; then

            getFilesInDirectory "$(realpath ./"$2")"

        else

            echo "Argument is not a folder"
            exit 6

        fi

    elif [ "$1" = "-a" ] || [ "$1" = "-b" ]; then   # if argument is -b|-a

        getFilesInDirectoryByDate "$1" "$2" "$(realpath .)"

    elif [ "$1" = "-m" ]; then                      # if argument is -m

        getMostEditedFile "$(realpath ./"$2")"

    else

        invalidArgument

    fi

elif [ "$#" = "3" ]; then # if program is triggered with three arguments

    if [ "$1" = "-a" ] || [ "$1" = "-b" ]; then     # if argument is -b|-a

        getFilesInDirectoryByDate "$1" "$2" "$(realpath ./"$3")"

    else

        invalidArgument

    fi

fi
