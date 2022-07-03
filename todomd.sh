#!/bin/zsh

# Inputs
# Number of years to generate from current year (default: 1)
# Destination directory (default: pwd)

# Input validations (Exit script if any are invalid)
# Number must be integer and greater than or equal to 1
# Destination directory must exist

echo ```
cal -h
echo ```
echo "\n"

number_of_days_in_week=7
year=$(cal -h | head -1 | tail -1 | xargs)
first_week_days=${$(echo $(cal -h | head -3 | tail -1)): -1}
starting_day_offset=$((number_of_days_in_week - first_week_days))
last_day=${$(echo $(cal -h)): -1}

echo "Last day: $last_day"
echo "Starting day offset: $starting_day_offset"
echo "Year: $year"

# Loop from current year to end year
## For each year
### If the year already exists in destination directory, log warning and skip creation
### If the year doesn't exist, we create the year directory
#### For each month
##### If the month file already exists, log warning and skip creation
##### If the month file doesn't exist, parse cal command into template
###### Paste result into the md file

