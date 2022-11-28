#!/bin/zsh

generate_heading () {
  local year=$(cal -h $1 $2 | head -1 | tail -1 | xargs)

  echo "# $year"
  echo "\`\`\`"
  cal -h $1 $2 | tail -n+2
  echo "\`\`\`"
  echo "\n"
  generate_formatting_rules_and_labels
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

# todo: make this dynamic
generate_formatting_rules_and_labels () {
  echo "## Formatting"
  echo "\`\`\`"
  echo "This format ensure todo description is jotted down first. There are no required entries in the second or third column. Increment the carry over count if the todo was not accomplished and is carried over to the next day."
  echo "Example:"
  echo "- [ ] todo description | todo type : goal type @ datetime e estimate c carryover count | optional notes"
  echo "\`\`\`"
  echo "\n"
  echo "## Labels"
  echo "\n"
  echo "### Goal types"
  echo "* career" 
  echo "* finance" 
  echo "* health" 
  echo "* relationship" 
  echo "\n"
  echo "### Todo types"
  echo "* chore: everyday tasks that are not high priority but have to be done at some point (ie. setup ikea cabinet, make phone call to setup appointment)"
  echo "* project: personal projects to achieve career goals (ie. build S3 static site)"
  echo "* study: personal learning to achieve career goals (ie. watch python course)"
  echo "* job: task that needs to be done at my job (ie. PR reviews, send emails)"
  echo "* plan: research and preparation tasks (ie. look for pet insurance, prepare for code interview)"
  echo "* read: tracking what book I've been reading (ie. read candlestick investing pg 20~40)"
  echo "* notes: tracking notes that I've taken (ie. what is SAML?)"
  echo "* workout: tracking my exercise routine (ie. run 4 miles)"
  echo "* budget: track financial reports"
  echo "* cook: tracking what I have cooked (ie. cook lo mein)"
  echo "* groceries: tracking what food I have to buy (ie. apples, ginger, etc)"
  echo "* buy: tracking everyday things I need to buy (ie. toilet paper, gas, etc)"
  echo "* appointment: any sort of appointment unrelated to my job (ie. dental checkup, pet grooming, etc)"
  echo "* reminder: any sort of misc tasks that need to be jotted down for future reference (ie. buy birthday present)"
  echo "* todo: any task that doesn't fit a specific label (ie. drive to Las Vegas)"
  echo "* sleep: track when I go to bed"
  echo "\n"
}

generate_monthly_goals () {
  echo "## Monthly Goals"
  echo "- [ ]"
  echo "\n"
}

generate_weekly_goals () {
  echo "## $1 Week Goals"
  echo "- [ ]"
  echo "\n"
}

generate_daily_todos () {
  local day_name=$(get_day_name_by_index $1)
  local date="### $day_name $2/$3"
  echo $date
  generate_required_task_by_day $3
  echo "\n"
}

# todo: make this dynamic
generate_required_task_by_day () {
  if [[ $1 == 1 ]]
  then
    echo "- [ ] pay rent | chore:finance" 
  elif [[ $1 == 19 ]]
  then
    echo "- [ ] pay credit card | chore:finance" 
  else
    echo "- [ ]" 
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

