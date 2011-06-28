;+
; NAME:
;
;    cal_WHI
;
; AUTHOR:
;
;    wuyuguo
;    irisksys@gmail.com
;
; PURPOSE:
;
;    calculate the WHI (Willis Hurricane Index)
;
;
; CALLING SEQUENCE:
;
;    PDI = cal_WHI (Vm, Rh, Vt, Vm0=Vm0, Rh0=Rh0, Vt0 = Vt0, a = a, b = b, c = c, aa = aa, bb = bb, cc = cc)
;
; INPUTS:
;
;     Vm: sustained maximum windspeed near tropical cyclone center,unit: m/s
;     Rh: radius of tropical cyclone in a specified level,unit: km. e.g. hurricane radius(radius of Lv.12 wind),
;     radius of Lv.10 wind or tropical storm radius(radius of Lv.8 wind).In this case,it's radius of Lv.8 wind
;     Vt: move speed of tropical cyclone,unit: m/s.it approximately equals to (center position next moment - center
;     position current moment)/(6*3600)
;
;     parameters:
;     Vm0: 33m/s
;     Rh0: radius of Lv.12,reference value: 96.9km
;          radius of Lv.10,reference value: 115.0km
;          radius of Lv.8,reference value: 200.0km
;     Vt0: 7.72m/s
;     a,b,c:the weight coefficient,the value is 1,5,5
;     aa = 3, bb = 1, cc = 2
;
; OPTIONAL INPUTS:
;
;
; KEYWORD PARAMETERS:
;
;
; OUTPUTS:
;
;      a float variable, i.e. WHI
;
; WHI stands for Willis Hurricane Index, come up by Greg Holland of Willis team in 2009.
;   WHI = a * (Vm/Vm0)^aa + b * (Rh/Rh0)^aa + c * (Vt/Vt0)^cc 
;-

function cal_WHI, Vm, Rh, Vt, Vm0=Vm0, Rh0=Rh0, Vt0 = Vt0, a = a, b = b, c = c, aa = aa, bb = bb, cc = cc
  WHI = a * (Vm/Vm0)^aa + b * (Rh/Rh0)^aa + c * (Vt/Vt0)^cc
  return, WHI
end 