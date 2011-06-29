;+
; NAME:
;
;    get_PDI
;
; AUTHOR:
;
;    wuyuguo
;    irisksys@gmail.com
;
; PURPOSE:
;
;    calculate the PDI (Power Dissipation Index)
;    PDI stands for Power Dissipation Index, show striking variations from year to year and 
;    on longer time scales (Bell et al. 2000).
;       PDI = 0.0001 * Σ （v^3)
;
; CALLING SEQUENCE:
;
;    result = get_PDI (V, unit = unit)
;
; ARGUMENTS:
;
;    V: a vector of windspeed at every 6 hours of a tropical cyclone
;
; KEYWORDS:
;    unit: the unit of wind speed. default is knot (unit = 0), 
;    m/s (unit = 1), or km/h (unit =2)
;
; OUTPUTS:
;
;    a float scaler, i.e., PDI of a tropical cyclone
;
; EXAMPLE:
;
; MODIFICATION_HISTORY:
;    Yuguo Wu, irisksys@gmail.com. June 28th 2011
;    rewrite
;-

function get_PDI, V, unit = unit

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
  endif
  
  ; calculate and return ACE
    return, 0.0001 * total(V_ACE^3)
  
end