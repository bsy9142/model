;+
; NAME:
;
;    get_BHI
;
; AUTHOR:
;
;    wuyuguo
;    irisksys@gmail.com
;
; PURPOSE:
;
;    calculate the BHI (BNU Hurricane Index), built by Professor Weihua Fang research team 
;    in Mar 2007. It's based on Chinese historical typhoon track and disaster statistics, 
;    shows Chinese typhoon integrated hazard level
;    BHI = (((1010 - Pc)/Pc0)^3 + (Prec/Prec0)^3) * (Rh/Rh0) * (Vt/Vt0) * t
;
; CALLING SEQUENCE:
;
;    result = get_BHI (Pc, Prec, Rh, Vt, T, unit = unit, Pc0 = Pc0, Prec0 = Prec0, Vt0 = Vt0, Rh0 = Rh0)
;
; ARGUMENTS:
;
;    Pc: lowest air pressure at sea level of tropical cyclone center, unit: hPa
;    Prec: maximum accumulated precipitation of station(or grid) influenced by tropical cyclone,unit: mm
;    Rh: radius of tropical cyclone in a specified level,unit: km. e.g. hurricane radius(radius of Lv.12 wind),
;    radius of Lv.10 wind or tropical storm radius(radius of Lv.8 wind).In this case,it's radius of Lv.8 wind
;    Vt: move speed of tropical cyclone,unit: m/s.it approximately equals to (center position next moment - center
;    position current moment)/(6*3600) if the data source lack the value
;    T: the number of cyclone center points landed until current moment or entire typhoon process. 
;
; KEYWORDS:
;
;    unit: the unit of wind speed. default is m/s (unit = 1), 
;    knot (unit = 0), or km/h (unit =2)
;    Pc0: 40hPa
;    Prec0: 440 mm
;    Vt: 8m/s
;    Rh0: radius of Lv.12,reference value: 96.9km
;         radius of Lv.10,reference value: 115.0km
;         radius of Lv.8,reference value: 200.0km
;
; OUTPUTS:
;
;    a float scaler, i.e. BHI
;
; EXAMPLE:
;
; MODIFICATION_HISTORY:
;    Yuguo Wu, irisksys@gmail.com. June 28th 2011
;    add some checking code
;-

function cal_BHI, Pc, Prec, Rh, Vt, T, unit = unit, Pc0 = Pc0, Prec0 = Prec0, Vt0 = Vt0, Rh0 = Rh0

  ; Return to caller on an error.
  On_Error, 2
  
    if keyword_set(unit) then begin
    CASE unit OF
      0: unit_mutiplier = 0.51444
      1: unit_mutiplier = 1
      2: unit_mutiplier = 0.27778
      ELSE: return, -1
    ENDCASE
    if keyword_set(Vt) then Vt = Vt * unit_mutiplier
    if keyword_set(Vt0) then Vt0 = Vt0 * unit_mutiplier
  endif
  if ~ keyword_set(Pc0) then Pc0 = 40
  if ~ keyword_set(Prec0) then Prec0 = 440
  if ~ keyword_set(Vt0) then Vt0 = 8
  if ~ keyword_set(Rh0) then Rh0 = 200
  
  return, (((1010 - Pc)/Pc0)^3 + (Prec/Prec0)^3) * (Rh/Rh0) * (Vt/Vt0) * t

end