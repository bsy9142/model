;+
; NAME:
;
;    cal_CHI
;
; AUTHOR:
;
;    wuyuguo
;    irisksys@gmail.com
;
; PURPOSE:
;
;    calculate the CHI (CME Hurricane Index)
;
;
; CALLING SEQUENCE:
;
;    PDI = cal_CHI (Vm, Rh, Vm0=Vm0, Rh0=Rh0)
;
; INPUTS:
;
;     Vm: sustained maximum windspeed near tropical cyclone center,unit: m/s
;     Rh: radius of tropical cyclone in a specified level,unit: km. e.g. hurricane radius(radius of Lv.12 wind),
;     radius of Lv.10 wind or tropical storm radius(radius of Lv.8 wind).In this case,it's radius of Lv.8 wind
;
;     parameters:
;     Vm0: 33m/s
;     Rh0: radius of Lv.12,reference value: 96.9km
;          radius of Lv.10,reference value: 115.0km
;          radius of Lv.8,reference value: 200.0km
;
; OPTIONAL INPUTS:
;
;
; KEYWORD PARAMETERS:
;
;
; OUTPUTS:
;
;      a float variable, i.e. CHI
;
; CHI stands for CME Hurricane Index, come up by Chicago Mercantile Exchange in Mar 2007.
;   CHI = (Vm/Vm0)^3 + 1.5 * (Rh/Rh0) * (Vm/Vm0)^2 
;-

function cal_CHI, Vm, Rh, Vm0=Vm0, Rh0=Rh0
  CHI = (Vm/Vm0)^3 + 1.5 * (Rh/Rh0) * (Vm/Vm0)^2
  return, CHI
end