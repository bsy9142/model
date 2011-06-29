;+
; NAME:
;
;    get_WHI
;
; AUTHOR:
;
;    wuyuguo
;    irisksys@gmail.com
;
; PURPOSE:
;
;    calculate the WHI. WHI stands for Willis Hurricane Index, come up by Greg Holland of
;    Willis team in 2009.
;    WHI = a * (Vm/Vm0)^aa + b * (Rh/Rh0)^aa + c * (Vt/Vt0)^cc
;
;
; CALLING SEQUENCE:
;
;    result = get_WHI (Vm, Rh, Vt, Vm0 = Vm0, Rh0 = sRh0, Vt0 = Vt0, a = a, b = b, c = c, aa = aa, bb = bb, cc = cc)
;
; ARGUMENTS:
;
;    Vm: sustained maximum windspeed near tropical cyclone center,unit: m/s
;    Rh: radius of tropical cyclone in a specified level,unit: km. e.g. hurricane radius
;    (radius of Lv.12 wind), radius of Lv.10 wind or tropical storm radius(radius of Lv.8 
;    wind).In this case,it's radius of Lv.8 wind
;    Vt: move speed of tropical cyclone,unit: m/s.it approximately equals to (center 
;    position next moment - center position current moment)/(6*3600)
;
; KEYWORDS:
;    Vm0: 33m/s
;    Rh0: radius of Lv.12,reference value: 96.9km
;         radius of Lv.10,reference value: 115.0km
;         radius of Lv.8,reference value: 200.0km
;    Vt0: 7.72m/s
;    a,b,c:the weight coefficient,the value is 1,5,5
;    aa = 3, bb = 1, cc = 2
;
; OUTPUTS:
;
;    a scaler, i.e. WHI
;
; EXAMPLE:
;
; MODIFICATION_HISTORY:
;    Yuguo Wu, irisksys@gmail.com. June 28th 2011
;    add some checking code
;-

function cal_WHI, Vm, Rh, Vt, Vm0 = Vm0, Rh0 = Rh0, Vt0 = Vt0, a = a, b = b, c = c, aa = aa, bb = bb, cc = cc
  
  ; Return to caller on an error.
  On_Error, 2
   
  if ~ keyword_set(Vm0) then Vm0 = 33
  if ~ keyword_set(Rh0) then Rh0 = 200
  if ~ keyword_set(Vt0) then Vm0 = 7.72
  if ~ keyword_set(a) then Vm0 = 1
  if ~ keyword_set(b) then Vm0 = 5
  if ~ keyword_set(c) then Vm0 = 5
  if ~ keyword_set(aa) then Vm0 = 3
  if ~ keyword_set(bb) then Vm0 = 1
  if ~ keyword_set(cc) then Vm0 = 2
    
  return, a * (Vm/Vm0)^aa + b * (Rh/Rh0)^aa + c * (Vt/Vt0)^cc
end 