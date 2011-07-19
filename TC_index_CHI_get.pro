;+
; NAME:
;
;    TC_index_CHI_get
;
; AUTHOR:
;
;    wuyuguo
;    irisksys@gmail.com
;
; PURPOSE:
;
;    calculate the CHI (CME Hurricane Index), come up by Chicago Mercantile Exchange in Mar 2007.
;    CHI = (Vm/Vm0)^3 + 1.5 * (Rh/Rh0) * (Vm/Vm0)^2 
;
; CALLING SEQUENCE:
;
;    result = TC_index_CHI_get (Vm, Rh, unit = unit, Vm0=Vm0, Rh0=Rh0)
;
; ARGUMENTS:
;
;     Vm: sustained maximum windspeed near tropical cyclone center,unit: m/s
;     Rh: radius of tropical cyclone in a specified level,unit: km. e.g. hurricane radius
;     (radius of Lv.12 wind), radius of Lv.10 wind or tropical storm radius(radius of Lv.8
;     wind).In this case,it's radius of Lv.8 wind
;
; KEYWORDS:
;
;    unit: the unit of wind speed. default is m/s (unit = 1), 
;    knot (unit = 0), or km/h (unit =2)
;    Vm0: 33m/s
;    Rh0: radius of Lv.12,reference value: 96.9km
;         radius of Lv.10,reference value: 115.0km
;         radius of Lv.8,reference value: 200.0km
; OUTPUTS:
;
;    a float scaler, i.e. CHI
;
; EXAMPLE:
;
; MODIFICATION_HISTORY:
;    Yuguo Wu, irisksys@gmail.com. June 28th 2011
;    add some checking code
;-

function TC_index_CHI_get, Vm, Rh, unit = unit, Vm0=Vm0, Rh0=Rh0
  ; Return to caller on an error.
  On_Error, 2
  
  if keyword_set(unit) then begin
    CASE unit OF
      0: unit_mutiplier = 0.51444
      1: unit_mutiplier = 1
      2: unit_mutiplier = 0.27778
      ELSE: return, -1
    ENDCASE
    if keyword_set(Vm) then Vm = Vm * unit_mutiplier
    if keyword_set(Vm0) then Vm0 = Vm0 * unit_mutiplier
  endif
  if ~ keyword_set(Vm0) then Vm0 = 33
  if ~ keyword_set(Rh0) then Rh0 = 200
  return, (Vm/Vm0)^3 + 1.5 * (Rh/Rh0) * (Vm/Vm0)^2
end