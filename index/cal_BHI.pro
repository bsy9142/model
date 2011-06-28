;+
; NAME:
;
;    cal_BHI
;
; AUTHOR:
;
;    wuyuguo
;    irisksys@gmail.com
;
; PURPOSE:
;
;    calculate the BHI (BNU Hurricane Index)
;
;
; CALLING SEQUENCE:
;
;    PDI = cal_BHI (Pc, Prec, Rh, Vt, T, Pc0 = Pc0, Prec0 = Prec0, Vt0 = Vt0, Rh0 = Rh0)
;
; INPUTS:
;
;     Pc: lowest air pressure at sea level of tropical cyclone center, unit: hPa
;     Prec: maximum accumulated precipitation of station(or grid) influenced by tropical cyclone,unit: mm
;     Rh: radius of tropical cyclone in a specified level,unit: km. e.g. hurricane radius(radius of Lv.12 wind),
;     radius of Lv.10 wind or tropical storm radius(radius of Lv.8 wind).In this case,it's radius of Lv.8 wind
;     Vt: move speed of tropical cyclone,unit: m/s.it approximately equals to (center position next moment - center
;     position current moment)/(6*3600) if the data source lack the value
;     T: the number of cyclone center points landed until current moment or entire typhoon process. 
;
;     parameters:
;     Pc0: 40hPa
;     Prec0: 440 mm
;     Vt: 8m/s
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
;      a float variable, i.e. BHI
;
; CHI stands for BNU Hurricane Index, built by Professor Fang Weihua research team in Mar 2007. It's based on Chinese
; historical typhoon track and disaster statistics, shows Chinese typhoon integrated hazard level
;   BHI = (((1010 - Pc)/Pc0)^3 + (Prec/Prec0)^3) * (Rh/Rh0) * (Vt/Vt0) * t
;-

function cal_BHI, Pc, Prec, Rh, Vt, T, Pc0 = Pc0, Prec0 = Prec0, Vt0 = Vt0, Rh0 = Rh0
  BHI = (((1010 - Pc)/Pc0)^3 + (Prec/Prec0)^3) * (Rh/Rh0) * (Vt/Vt0) * t
  return, BHI
end