;+
; NAME:
;
;    get_ACE
;
; AUTHOR:
;
;    wuyuguo
;    irisksys@gmail.com
;
; PURPOSE:
;
;    Accumulated cyclone energy (ACE) is a measure used by the National Oceanic and 
;    Atmospheric Administration (NOAA) to express the activity of individual tropical 
;    cyclones and entire tropical cyclone seasons, particularly the North Atlantic hurricane 
;    season. It uses an approximation of the energy used by a tropical system over its lifetime
;    and is calculated every six-hour period. The ACE of a season is the sum of the ACEs for 
;    each storm and takes into account the number, strength, and duration of all the tropical
;    storms in the season.
;
;    The ACE of a season is calculated by summing the squares of the estimated maximum
;    sustained velocity of every active tropical storm (wind speed 35 knots (65 km/h) or
;    higher), at six-hour intervals. If any storms of a season happen to cross years, the
;    storm's ACE counts for the previous year.[2] The numbers are usually divided by 10,000
;    to make them more manageable. The unit of ACE is 10000 kt2, and for use as an index the
;    unit is assumed. Thus:

;       ACE = 10^(-4) * Σ (Vmax^2), where vmax is estimated sustained wind speed in
;       knots.

;    Kinetic energy is proportional to the square of velocity, and by adding together the 
;    energy per some interval of time, the accumulated energy is found. As the duration of a
;    storm increases, more values are summed and the ACE also increases such that
;    longer-duration storms may accumulate a larger ACE than more-powerful storms of 
;    lesser duration. Although ACE is a value proportional to the energy of the system, it is 
;    not a direct calculation of energy (the mass of the moved air and therefore the size of the 
;    storm would show up in a real energy calculation).

;
; CALLING SEQUENCE:
;
;    result = get_ACE (V, threshold = threshold, unit = unit)
;
; ARGUMENTS:
;
;    V: a vector of windspeed at every 6 hours of a tropical cyclone
;
; KEYWORDS:
;
;    threshold: the threshold of wind speed. Default is 35 knots. The unit of V and threshold 
;    must be the same unit     : the unit of wind speed. default is knot (unit = 0), 
;    m/s (unit = 1), or km/h (unit =2)
;
; OUTPUTS:
;
;    a float scaler, i.e., ACE of a tropical cyclone
;
; EXAMPLE:
;
; MODIFICATION_HISTORY:
;    Written by Weihua FANG, weihua.fang@gmail.com. June, 28, 2011
;    Many errors in previous code (cal_ACE). So rewrite the whole thing.

function get_ACE, V, threshold = threshold, unit = unit

  ; Return to caller on an error.
   On_Error, 2

  ; unit conversion
  if keyword_set(unit) then begin
    CASE unit OF
      0: unit_mutiplier = 1
      1: unit_mutiplier = 1.94384449
      2: unit_mutiplier = 0.539956
      ELSE: return, -1
    ENDCASE
    V = V * unit_mutiplier
    if keyword_set(threshold) then threshold = threshold * unit_mutiplier
  endif
  
  ; set wind threshold (default, 35 kt)
  if ~keyword_set(threshold) then begin
    threshold = 35.0
  endif
  
  ; calculate and return ACE
  subscript_tmp = where (V GE threshold, count_tmp)
  if count_tmp GT 0 then begin
    V_ACE = V [subscript_tmp]
    return, 0.0001 * total(V_ACE^2)
  endif else begin
    return, 0
  endelse
  
end