;+
; NAME:
;
;    cal_PDI
;
; AUTHOR:
;
;    wuyuguo
;    irisksys@gmail.com
;
; PURPOSE:
;
;    calculate the PDI (Power Dissipation Index)
;
;
; CALLING SEQUENCE:
;
;    PDI = cal_PDI (V, unit = unit, Vmin = Vmin)
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
;      a float variable, i.e. PDI
;
; PDI stand for Power Dissipation Index, show striking variations from year to year and on longer time scales 
; (Bell et al. 2000).
;    PDI = 0.0001 * Σ （v^3)
;-

function cal_PDI, V, unit = unit, Vmin = Vmin

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
  PDI = 0
  for i_v = 0, n_elements(V) - 1 do begin
    PDI = PDI + V(i_v)^3
  endfor
  
  return, 0.0001 * PDI
end