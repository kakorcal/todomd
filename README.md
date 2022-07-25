# todomd

Command line calendar todo generator in markdown

## Usage

Input
```
./todomd.sh -m 7 -y 2022 
```

Output
```
# July 2022
Su Mo Tu We Th Fr Sa 
                1  2  
 3  4  5  6  7  8  9  
10 11 12 13 14 15 16  
17 18 19 20 21 22 23  
24 25 26 27 28 29 30  
31


### Leading Week Goals
- [ ]
- [ ]
- [ ]


### Fri 7/1
- [ ]
- [ ]
- [ ]


### Sat 7/2
- [ ]
- [ ]
- [ ]


## 1st Week Goals
- [ ]
- [ ]
- [ ]


### Sun 7/3
- [ ]
- [ ]
- [ ]


### Mon 7/4
- [ ]
- [ ]
- [ ]


### Tues 7/5
- [ ]
- [ ]
- [ ]


### Wed 7/6
- [ ]
- [ ]
- [ ]

...
```

## Options
1. m: Specifies which month to generate todos. Accepts values from 1~12
2. y: Specifies which year to generate todos. Accepts values greater than 0. If month is not specified, it will generate todos for each month of the year.
3. o: Specifies output directory of the generated todos. Is only supported for the case when only the year is specified
