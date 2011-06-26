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
; The ACE of a season is calculated by summing the squares of the estimated maximum sustained velocity of 
; every active tropical storm (wind speed 35 knots (65 km/h) or higher), at six-hour intervals. 
; If any storms of a season happen to cross years, the storm's ACE counts for the previous year.
; The numbers are usually divided by 10,000 to make them more manageable. The unit of ACE is 104 kt2, 
; and for use as an index the unit is assumed. Thus:
;    ACE = Σ (v^2)

; CALLING SEQUENCE:
;
;    ACE = cal_ace (V, unit = unit, Vmin=Vmin)
;
; INPUTS:
;
;     Sample: a m*n float array, different row represents different cyclone, column represents windspeed, every 6 hour
;     observed
  
;
; OPTIONAL INPUTS:
;     unit  : the unit of wind speed, default if knot, or others like m/s
;     Vmin  : the minimum value of wind speed to be calculated
;
; KEYWORD PARAMETERS:
;
;
;
; OUTPUTS:
;
;      a float variable, i.e. ACE
;
; References1.
; 1.^ a b Bell GD, Halpert MS, Schnell RC, et al (2000). "Climate Assessment for 1999". Bulletin of the American Meteorological Society 81: 1328. doi:10.1175/1520-0477(2000)081<1328:CAF>2.3.CO;2 
; 2.^ Last advisory for T.S. Zeta 2005
; 3.^ Climate Prediction Center — Background Information: The North Atlantic Hurricane Season
; 4.^ Goldberg SB, Landsea CW, Mestas-Nuñez AM, Gray WM (July 2001). "The Recent Increase in Atlantic Hurricane Activity: Causes and Implications". Science 293 (5529): 474–9. doi:10.1126/science.1060040. PMID 11463911 
; 5.^ Summary of 2000 Atlantic tropical cyclone activity and verification of authors’ seasonal activity prediction.
; 6.^ East North Pacific ACE (through 30 Nov. 2005)

;-

function cal_ACE, V, unit = unit, Vmin = Vmin

; conversion from m/s to knot 
  if strcmp (unit, 'm/s') then begin
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