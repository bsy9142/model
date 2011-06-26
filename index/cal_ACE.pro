;+
; NAME:
;
;    cal_ACE
;
; AUTHOR:
;
;    wuyuguo
;    irisksys@gmail.com
;
; PURPOSE:
;
;    calculate the accumulated cyclone energy
;
;
; CALLING SEQUENCE:
;
;    ACE = cal_ace (V, unit = unit, Vmin=Vmin)
;
; INPUTS:
;
;     V: a m*n float array, different row represents different cyclone, column represents windspeed, every 6 hour
;     observed
;      
;
; OPTIONAL INPUTS:
;     unit  : the unit of wind speed, default if knotunit = 0), or m/s(unit = 1), or others
;     Vmin  : the minimum value of wind speed to be calculated, default is 64 kt
;
; KEYWORD PARAMETERS:
;
;
;
; OUTPUTS:
;
;      a float variable, i.e. ACE
;
;Accumulated cyclone energy
;From Wikipedia, the free encyclopediaJump to: navigation, search 
;Accumulated cyclone energy (ACE) is a measure used by the National Oceanic and Atmospheric Administration (NOAA)
;to express the activity of individual tropical cyclones and entire tropical cyclone seasons, particularly the 
;North Atlantic hurricane season. It uses an approximation of the energy used by a tropical system over its lifetime 
;and is calculated every six-hour period. The ACE of a season is the sum of the ACEs for each storm and takes into 
;account the number, strength, and duration of all the tropical storms in the season.[1]
;
;Contents [hide]
;1 Calculation
;2 Atlantic basin ACE 
;  2.1 Categories
;  2.2 Individual storms
;  2.3 ACE index chart for Atlantic hurricane seasons, 1950–2009
;  2.4 Atlantic hurricane seasons by ACE index, 1950–2010
;3 East Pacific ACE
;4 See also
;5 References
;6 External links
;
;
;Calculation
;The ACE of a season is calculated by summing the squares of the estimated maximum sustained velocity of every 
;active tropical storm (wind speed 35 knots (65 km/h) or higher), at six-hour intervals. If any storms of a season 
;happen to cross years, the storm's ACE counts for the previous year.[2] The numbers are usually divided by 10,000 
;to make them more manageable. The unit of ACE is 104 kt2, and for use as an index the unit is assumed. Thus:
;  ACE = 10^(-4) * Σ (Vmax^2)
;
;where vmax is estimated sustained wind speed in knots.

;Kinetic energy is proportional to the square of velocity, and by adding together the energy per some interval 
;of time, the accumulated energy is found. As the duration of a storm increases, more values are summed and the 
;ACE also increases such that longer-duration storms may accumulate a larger ACE than more-powerful storms of lesser 
;duration. Although ACE is a value proportional to the energy of the system, it is not a direct calculation of 
;energy (the mass of the moved air and therefore the size of the storm would show up in a real energy calculation).
;
;A related quantity is hurricane destruction potential (HDP), which is ACE but only calculated for the time where 
;the system is a hurricane.[1]
;
;Atlantic basin ACE
;
;Categories 
;Atlantic basin cyclone intensity by Accumulated cyclone energy, timeseries 1895-2007A season's ACE is used to 
;categorize the hurricane season by its activity. Measured over the period 1951–2000 for the Atlantic basin, 
;the median annual index was 87.5 and the mean annual index was 93.2. The NOAA categorisation system[3] divides 
;seasons into:
;• Above-normal season: An ACE value above 103 (117% of the 1951–2000 median), provided at least two of the following 
;  three parameters exceed the long-term average: number of tropical storms (10), hurricanes (6), and major hurricanes (2).
;• Near-normal season: neither above-normal nor below normal
;• Below-normal season: An ACE value below 66 (75% of the 1951–2000 median)
;
;Individual storms
;The highest ever ACE estimated for a single storm in the Atlantic is 73.6, for Hurricane San Ciriaco in 1899. 
;This single storm had an ACE higher than many whole Atlantic storm seasons. Other Atlantic storms with high ACEs 
;include Hurricane Ivan in 2004, with an ACE of 70.4, Hurricane Donna in 1960, with an ACE of 64.6, Hurricane Isabel 
;in 2003 with an ACE of 63.28, and the Great Charleston Hurricane of 1893 with an ACE of 63.5.

;ACE index chart for Atlantic hurricane seasons, 1950–2009The blue line (with the scale on the left) represents the 
;total Accumulated Cyclone Energy Index for the entire Atlantic season, and the red line (with the scale on the right) 
;is the average ACE per storm for that season.

;Atlantic hurricane seasons by ACE index, 1950–2010
;The term hyperactive is used by Goldenberg et al. (2001) [4] based on a different weighting algorithm[5] which 
;places more weight on major hurricanes, but typically equating to an ACE of about 153 (171% of the current median). 
;For the in progress season be advised that the ACE is preliminary based on NHC bulletins, which may later be revised.

;Key 
;• ACE   Accumulated cyclone energy 
;• TS Number of tropical storms (including subtropicals) 
;• HR Number of hurricanes (S-S Category 1 – 5) 
;• MH Number of major hurricanes (Category 3 – 5) 
 
;(Fields with record values are in bold) 

;For definitions of the terms "above", "near", and "below" normal, see the Categories section above.

;             Season            ACE TS HR MH       Classification 
;2005 Atlantic hurricane season 248 28 15 7 Above normal (hyperactive) 
;1950 Atlantic hurricane season 243 13 11 8 Above normal (hyperactive) 
;1995 Atlantic hurricane season 228 19 11 5 Above normal (hyperactive) 
;2004 Atlantic hurricane season 225 15  9 6 Above normal (hyperactive) 
;1961 Atlantic hurricane season 205 11  8 7 Above normal (hyperactive) 
;1955 Atlantic hurricane season 199 12  9 6 Above normal (hyperactive) 
;1998 Atlantic hurricane season 182 14 10 3 Above normal (hyperactive) 
;1999 Atlantic hurricane season 177 12  8 5 Above normal (hyperactive) 
;2003 Atlantic hurricane season 175 16  7 3 Above normal (hyperactive) 
;1964 Atlantic hurricane season 170 12  6 6 Above normal (hyperactive) 
;1996 Atlantic hurricane season 166 13  9 6 Above normal (hyperactive) 
;2010 Atlantic hurricane season 165 19 12 5 Above normal (hyperactive) 
;1969 Atlantic hurricane season 158 18 12 5 Above normal (hyperactive) 
;1980 Atlantic hurricane season 147 11  9 2 Above normal 
;1966 Atlantic hurricane season 145 11  7 3 Above normal 
;2008 Atlantic hurricane season 144 16  8 5 Above normal 
;1951 Atlantic hurricane season 137 10  8 5 Above normal 
;1989 Atlantic hurricane season 135 11  7 2 Above normal 
;1967 Atlantic hurricane season 122  8  6 1 Near normal 
;1958 Atlantic hurricane season 121 10  7 5 Above normal 
;1963 Atlantic hurricane season 118  9  7 2 Near normal 
;2000 Atlantic hurricane season 116 15  8 3 Above normal 
;1954 Atlantic hurricane season 113 11  8 2 Above normal 
;2001 Atlantic hurricane season 106 15  9 4 Above normal 
;1953 Atlantic hurricane season 104 14  6 4 Above normal 
;1988 Atlantic hurricane season 103 12  5 3 Above normal 
;1971 Atlantic hurricane season  97 13  6 1 Near normal 
;1981 Atlantic hurricane season  93 12  7 3 Near normal 
;1979 Atlantic hurricane season  91  9  5 2 Near normal 
;1990 Atlantic hurricane season  91 14  8 1 Near normal 
;1960 Atlantic hurricane season  88  7  4 2 Near normal 
;1985 Atlantic hurricane season  88 11  7 3 Near normal 
;1952 Atlantic hurricane season  87  7  6 3 Near normal 
;1965 Atlantic hurricane season  84  6  4 1 Near normal 
;1957 Atlantic hurricane season  84  8  3 2 Near normal 
;1976 Atlantic hurricane season  81 10  6 2 Near normal 
;2006 Atlantic hurricane season  79 10  5 2 Near normal 
;1959 Atlantic hurricane season  77 11  7 2 Near normal 
;1992 Atlantic hurricane season  75  7  4 1 Near normal 
;1975 Atlantic hurricane season  73  9  6 3 Near normal 
;2007 Atlantic hurricane season  72 15  6 2 Near normal 
;1984 Atlantic hurricane season  71 12  5 1 Near normal 
;2002 Atlantic hurricane season  65 12  4 2 Below normal 
;1978 Atlantic hurricane season  62 12  5 2 Below normal 
;1974 Atlantic hurricane season  61 11  4 2 Below normal 
;1956 Atlantic hurricane season  54  8  4 2 Below normal 
;2009 Atlantic hurricane season  51  9  3 2 Below normal 
;1973 Atlantic hurricane season  43  8  4 1 Below normal 
;1997 Atlantic hurricane season  40  7  3 1 Below normal 
;1993 Atlantic hurricane season  39  8  4 1 Below normal 
;1962 Atlantic hurricane season  36  5  3 1 Below normal 
;1986 Atlantic hurricane season  36  6  4 0 Below normal 
;1968 Atlantic hurricane season  35  8  4 0 Below normal 
;1970 Atlantic hurricane season  34 10  5 2 Below normal 
;1987 Atlantic hurricane season  34  7  3 1 Below normal 
;1991 Atlantic hurricane season  34  8  4 2 Below normal 
;1994 Atlantic hurricane season  32  7  3 0 Below normal 
;1982 Atlantic hurricane season  29  6  2 1 Below normal 
;1972 Atlantic hurricane season  28  7  3 0 Below normal 
;1977 Atlantic hurricane season  25  6  5 1 Below normal 
;1983 Atlantic hurricane season  17  4  3 1 Below normal

;Mean 1950–2009: 101.2
;Median 1950–2009: 88.0

;East Pacific ACE
;Accumulated Cyclone Energy is also used in the eastern and central Pacific Ocean. Data on ACE is considered reliable 
;starting with the 1971 season. The season with the highest ACE since 1971 is the 1992 season. The 1977 season has the 
;lowest ACE. The most recent above-normal season is the 2006 season, the most recent near-normal season is the 2009 
;season, and the most recent below normal season is the 2008 season.[6] The 35 year median 1971–2005 is 115 x 104kt2 
;(100 in the EPAC zone east of 140°W, 13 in the CPAC zone); the mean is 130 (112 + 18).

;The (unofficial) categorisation of seasons for this table is based mutatis mutandis on that used in the Atlantic basin:

;• Above-normal season: An ACE value above 135 (117% of the median), provided at least two of the following three 
;parameters exceed the long-term average: number of tropical storms (16), hurricanes (9), and major hurricanes (4).
;• Near-normal season: neither above-normal nor below normal
;• Below-normal season: An ACE value below 86 (75% of the median)

;           Season            ACE TS HR MH Classification 
;1992 Pacific hurricane season 290 28 16 10 Above normal 
;1990 Pacific hurricane season 249 21 16  6 Above normal 
;1978 Pacific hurricane season 207 19 14  7 Above normal 
;1983 Pacific hurricane season 206 21 12  8 Above normal 
;1993 Pacific hurricane season 201 15 11  9 Above normal 
;1984 Pacific hurricane season 193 21 13  7 Above normal 
;1985 Pacific hurricane season 192 23 13  8 Above normal 
;1994 Pacific hurricane season 185 20 10  5 Above normal 
;1991 Pacific hurricane season 178 14 10  5 Above normal 
;1997 Pacific hurricane season 167 19  9  7 Above normal 
;1982 Pacific hurricane season 161 23 12  5 Above normal 
;2006 Pacific hurricane season 155 19 11  6 Above normal 
;1971 Pacific hurricane season 139 18 12  6 Above normal 
;1972 Pacific hurricane season 136 14  8  4 Near normal 
;1998 Pacific hurricane season 133 13  9  6 Near normal 
;1987 Pacific hurricane season 132 20 10  4 Near normal 
;2009 Pacific hurricane season 125 20  8  5 Near normal 
;2002 Pacific hurricane season 124 15  8  6 Near normal 
;1976 Pacific hurricane season 121 15  9  5 Near normal 
;1973 Pacific hurricane season 114 12  7  3 Near normal 
;1988 Pacific hurricane season 114 15  7  3 Near normal 
;1975 Pacific hurricane season 112 17  9  4 Near normal 
;1989 Pacific hurricane season 110 17  9  4 Near normal 
;1986 Pacific hurricane season 107 17  9  3 Near normal 
;1995 Pacific hurricane season 100 10  7  3 Near normal 
;2005 Pacific hurricane season  96 15  7  2 Near normal 
;2000 Pacific hurricane season  95 19  6  2 Near normal 
;1974 Pacific hurricane season  90 18 11  3 Near normal 
;1999 Pacific hurricane season  90  9  6  2 Near normal 
;2001 Pacific hurricane season  90 15  8  2 Near normal 
;2008 Pacific hurricane season  83 15  7  2 Below normal 
;1980 Pacific hurricane season  77 14  7  3 Below normal 
;1981 Pacific hurricane season  72 15  8  1 Below normal 
;2004 Pacific hurricane season  71 12  6  3 Below normal 
;1979 Pacific hurricane season  57 10  6  4 Below normal 
;2003 Pacific hurricane season  56 16  7  0 Below normal 
;1996 Pacific hurricane season  53  9  5  2 Below normal 
;2007 Pacific hurricane season  53 11  4  1 Below normal 
;2010 Pacific hurricane season  49  7  3  2 Below normal 
;1977 Pacific hurricane season  22  8  4  0 Below normal;

;Mean 1971-2009: 127.07

;Median 1971-2009: 114

;Calculations from Eastern North Pacific Tracks File at NHC

;See also 
;Tropical cyclones portal 
;• List of Atlantic hurricane seasons

;References
;1.a b Bell GD, Halpert MS, Schnell RC, et al (2000). "Climate Assessment for 1999" (PDF). Bulletin of the American 
;Meteorological Society 81: 1328. doi:10.1175/1520-0477(2000)081<1328:CAF>2.3.CO;2.  
;2.Last advisory for T.S. Zeta 2005
;3.Climate Prediction Center — Background Information: The North Atlantic Hurricane Season
;4.Goldberg SB, Landsea CW, Mestas-Nuñez AM, Gray WM (July 2001). "The Recent Increase in Atlantic Hurricane Activity: 
;Causes and Implications" (PDF). Science 293 (5529): 474–9. doi:10.1126/science.1060040. PMID 11463911.  
;5.Summary of 2000 Atlantic tropical cyclone activity and verification of authors’ seasonal activity prediction.
;6.East North Pacific ACE (through 30 Nov. 2005)

;External links
;• NOAA ACE by year from 1851
;• National Climatic Data Center — Atlantic Basin 2004 Accumulated Cyclone Energy (ACE) Index
;• National Climatic Data Center — Atlantic Basin 2005 Accumulated Cyclone Energy (ACE) Index
;• 2004 Pacific NW Typhoon Season ACE pdf
;• Global Tropical Cyclone Best Track Database
;• Hurricane Metrics

;-

function cal_ACE, V, unit = unit, Vmin = Vmin

; conversion from m/s to knot 
  if  unit eq 1 then begin
    for i_v = 0, n_elements(V) - 1 do begin
      V(i_v) = V(i_v) / 0.514
      endfor
  endif
  
; sift windspeed below the standard (default threshold is 64 kt)
  for i_v = 0, n_elements(V) - 1 do begin
    if V(i_v) lt Vmin then V(i_v) = -1
  endfor
  V = V[where(V ne -1)]
  
; calculate the ACE
  ACE = 0
  for i_v = 0, n_elements(V) - 1 do begin
    ACE = ACE + V(i_v)^2
  endfor
  
  return, ACE
end