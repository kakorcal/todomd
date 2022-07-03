#!/bin/zsh

# Inputs
# Number of years to generate from current year (default: 1)
# Destination directory (default: pwd)

# Input validations (Exit script if any are invalid)
# Number must be integer and greater than or equal to 1
# Destination directory must exist

# Variables
# Current year
# End year

# Operation

# Display cal

cal -h

echo "\n"

year=$(cal -h | head -1 | tail -1 | xargs)
# weeknames=$(cal -h | head -2 | tail -1)
# firstweek=$(cal -h | head -3 | tail -1)
number_of_days_in_week=7
first_week_days=${$(echo $(cal -h | head -3 | tail -1)): -1}
starting_day_offset=$((number_of_days_in_week - first_week_days))
# | head -3 | tail -1 | rev | xargs | cut -c1)
last_day=${$(echo $(cal -h)): -1}

echo "Last day: $last_day"
echo "Starting day offset: $starting_day_offset"
echo "Year: $year"
# echo "Offset: $(($number_of_days - $starting_day_offset))"
# echo "Last Day: ${last_day:-1}"
#echo "Starting day offset: ${starting_day_offset}"

# Loop from current year to end year
## For each year
### If the year already exists in destination directory, log warning and skip creation
### If the year doesn't exist, we create the year directory
#### For each month
##### If the month file already exists, log warning and skip creation
##### If the month file doesn't exist, parse cal command into template
###### Paste result into the md file

# How do we parse the ncal command?
## 



