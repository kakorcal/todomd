#!/bin/zsh

generate_heading () {
  local year=$(cal -h $1 $2 | head -1 | tail -1 | xargs)

  echo "# $year"
  echo "\`\`\`"
  cal -h $1 $2 | tail -n+2
  echo "\`\`\`"
  echo "\n"
  generate_monthly_goals
}

generate_month () {
  local number_of_days_in_week=7
  local first_week_days=${$(echo $(cal -h $1 $2 | head -3 | tail -1)): -1}
  local day_name_index=$((number_of_days_in_week - first_week_days))
  local last_day=${$(echo $(cal -h $1 $2)): -1}
  local week_counter=0

  for i in {1..$last_day}
  do
    if [[ $day_name_index == 0 || $i == 1 ]]
    then
      local nth_week=$(get_nth_week $week_counter)
      generate_weekly_goals "$nth_week" 
      week_counter=$((week_counter + 1))
    fi

    generate_daily_todos $day_name_index $1 $i
    
    if [[ $day_name_index == 6 ]]
    then
      day_name_index=0
    else
      day_name_index=$((day_name_index + 1))
    fi
  done
}

generate_monthly_goals () {
  echo "## Monthly Goals"
  echo "- [ ] **main**"
  echo "- [ ]"
  echo "- [ ]"
  echo "\n"
}

generate_weekly_goals () {
  echo "## $1 Week Goals"
  echo "- [ ] **main**"
  echo "- [ ]"
  echo "- [ ]"
  echo "\n"
}

generate_daily_todos () {
  local day_name=$(get_day_name_by_index $1)
  local date="### $day_name $2/$3"
  echo $date
  generate_routines $1
  echo "\n"
}

# todo: make this dynamic
generate_routines () {
  if [[ $1 == 0 ]]
  then
    echo "- [ ] *groceries* | health | 1h 1000 |" 
    echo "- [ ] **budget** | finance | 1h 1300 | finanical report. compare with finance goals"
    echo "- [ ] *workout* | health | 1h 1700 | run, pullups, pushups"
    echo "- [ ] *cook* | health | 1h 1600 |"
    echo "- [ ] plan | n/a | 30m 2130 | play next day"
  elif [[ $1 == 1 ]]
  then
    echo "- [ ] workout | health | 1h 1700 | run, squats" 
    echo "- [ ] plan | n/a | 30m 2130 | play next day"
  elif [[ $1 == 2 ]]
  then
    echo "- [ ] read | career | 30m 0800 |"
    echo "- [ ] groceries | health | 1h 1000 |"
    echo "- [ ] cook | health | 1h 1600 |" 
    echo "- [ ] plan | n/a | 30m 2130 | play next day"
  elif [[ $1 == 3 ]]
  then
    echo "- [ ] read | career | 30m 0800 |"
    echo "- [ ] workout | health | 1h 1800 | walk po in park"
    echo "- [ ] plan | n/a | 30m 2130 | play next day"
  elif [[ $1 == 4 ]]
  then
    echo "- [ ] cook | health | 1h 1600 |" 
    echo "- [ ] workout | health | 1h 1700 | run, pullups, pushups" 
    echo "- [ ] plan | n/a | 30m 2130 | play next day"
  elif [[ $1 == 5 ]]
  then
    echo "- [ ] groceries | health | 1h 1000 |"
    echo "- [ ] workout | health | 1h 1700 | run, squats" 
    echo "- [ ] plan | n/a | 30m 2130 | play next day"
  elif [[ $1 == 6 ]]
  then
    echo "- [ ] read | career | 30 0800 |"
    echo "- [ ] cook | health | 1h 1600 |" 
    echo "- [ ] workout | health | 1h 1800 | walk po in park"
    echo "- [ ] plan | n/a | 30m 2130 | play next day"
  else
    echo "Error: invalid argument for generate_routines $1"
  fi
}

get_nth_week () {
  if [[ $1 == 0 ]]
  then
    echo "Leading"
  elif [[ $1 == 1 ]]
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
    echo "Trailing"
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
    echo "Error: invalid argument for get_day_name_by_index $1"
  fi
}

todomd () {
  generate_heading $1 $2
  generate_month $1 $2
}

main () {
  local month=0
  local year=0
  local outdir=todomd

  while getopts ":m:y:o:" option; do
    case $option in
      m) # month
        month=$OPTARG;;
      y) # year
        year=$OPTARG;;
      o) # outdir
        outdir=$OPTARG;;
      \?) # Invalid option
        echo "Error: invalid option $OPTARG"
        exit;;
    esac
  done

  if [[ $month -gt 0 && $year -gt 0 ]]
  then
    if [[ -f "$month.md" ]] 
    then
      echo "Error: file '$month.md' already exists"
      exit
    else
      todomd $month $year > $month.md
    fi
  elif [[ $month == 0 && $year -gt 0 ]]
  then
    if [[ -d $outdir ]]
    then
      echo "Error: directory '$outdir' already exists"
      exit
    else
      mkdir -p $outdir/$year
    fi

    for i in {1..12}
    do
      todomd $i $year > $outdir/$year/$i.md
    done
  else
    echo "Error: options out of range"
  fi
}

main "$@"

