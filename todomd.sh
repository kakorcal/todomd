#!/bin/zsh

generate_month () {
  local number_of_days_in_week=7
  local first_week_days=${$(echo $(cal -h $1 $2 | head -3 | tail -1)): -1}
  local day_name_index=$((number_of_days_in_week - first_week_days))
  local last_day=${$(echo $(cal -h $1 $2)): -1}
  local week_counter=1

  for i in {1..$last_day}
  do
    if [[ $day_name_index == 0 ]]
    then
      local nth_week=$(get_nth_week $week_counter)
      if [[ week_counter -lt 5 ]]
      then
        generate_todos "## $nth_week Week Goals:"
        week_counter=$((week_counter + 1))
      fi  
    fi

    local day_name=$(get_day_name_by_index $day_name_index)
    generate_todos "### $day_name $1/$i"
    
    if [[ $day_name_index == 6 ]]
    then
      day_name_index=0
    else
      day_name_index=$((day_name_index + 1))
    fi
  done
}

generate_todos () {
  echo $1
  echo "- [ ]"
  echo "- [ ]"
  echo "- [ ]"
  echo "\n"
}

get_nth_week () {
  if [[ $1 == 1 ]]
  then
    echo "1st"
  elif [[ $1 == 2 ]]
  then
    echo "2nd"
  elif [[ $1 == 3 ]]
  then
    echo "3rd"
  elif [[ $1 == 4 ]]
  then
    echo "4th"
  else
    echo "INVALID ARGUMENT FOR get_nth_week $1"
  fi

}

get_day_name_by_index () {
  if [[ $1 == 0 ]]
  then
    echo "Sun"
  elif [[ $1 == 1 ]]
  then
    echo "Mon"
  elif [[ $1 == 2 ]]
  then
    echo "Tues"
  elif [[ $1 == 3 ]]
  then
    echo "Wed" 
  elif [[ $1 == 4 ]]
  then
    echo "Thur"
  elif [[ $1 == 5 ]]
  then
    echo "Fri"
  elif [[ $1 == 6 ]]
  then
    echo "Sat" 
  else
    echo "INVALID ARGUMENT FOR generate_day_by_index $1"
  fi
}

main () {
 local year=$(cal -h $1 $2 | head -1 | tail -1 | xargs)
 echo "# $year"
 echo "\n"
 echo "\`\`\`"
 cal -h $1 $2 | tail -n+2
 echo "\`\`\`"
 echo "\n"
 generate_month $1 $2
}

main 3 2022
