;+
; NAME:
;
;    get_CHI
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
;    result = get_CHI (Vm, Rh, Vm0=Vm0, Rh0=Rh0)
;
; ARGUMENTS:
;
;     Vm: sustained maximum windspeed near tropical cyclone center,unit: m/s
;     Rh: radius of tropical cyclone in a specified level,unit: km. e.g. hurricane radius
;     (radius of Lv.12 wind), radius of Lv.10 wind or tropical storm radius(radius of Lv.8
;     wind).In this case,it's radius of Lv.8 wind
;
; KEYWORDS:
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

function get_CHI, Vm, Rh, Vm0=Vm0, Rh0=Rh0
  ; Return to caller on an error.
  On_Error, 2
  
  if ~ keyword_set(Vm0) then Vm0 = 33
  if ~ keyword_set(Rh0) then Rh0 = 200
  return, (Vm/Vm0)^3 + 1.5 * (Rh/Rh0) * (Vm/Vm0)^2
end