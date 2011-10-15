;+
; NAME:
;
;    track_interpo104
;
; AUTHOR:
;
;    Yin Yunjian
;    yinyunjian@bnu.edu.cn
;    Li Xinyi
;    lixinyi@bnu.edu.cn
;
; PURPOSE:
;
;    The code is aimed at presenting the interpolated points in a tropical cyclone track by 
;    the fourth method, which interpolates the given points by comparing the errors of linear,
;    quadratic, spline to the known and hidden central point and choosing the best one. And
;    thus, we call the fourth method as a "combination" method.
;
; CALLING SEQUENCE:
;
;   result = track_interpo104(a)
;
; ARGUMENTS:
;
;    a: a float vector, the ID number of the tropical cyclone, recorded every 6h
;
; KEYWORDS:
;
; OUTPUTS:
;
;    a float vector, including the interpolated points in the variable a, every 15min
;
; EXAMPLE:
;
;    IDL> path = file_search('D:\Tc_track\point\','*.shp')  ;读取所有台风的数据
;    IDL> a = shape_attribute_read(path,'lon')  ;所有经度的数据
;    PRINT, track_interpo104(a)
;
; MODIFICATION_HISTORY:
;

function interpol04, a   ;每一小时插一个值
n = n_elements(a)
y = [a[0], a[1]]
x = [0, 6]
xx = findgen(7)
s = interpol(y, x, xx)
for i = 2, n - 3 do begin
  y1 = [a[i - 1], a[i + 1]]
  x1 = [0, 12]
  xx1 = 6
  s1 = interpol(y1, x1, xx1)
  y2 = [a[i - 2], a[i - 1], a[i + 1]]
  x2 = [0, 6, 18]
  xx2 = 12
  s2 = interpol(y2, x2, xx2, /quadratic)
  y3 = [a[i - 2], a[i - 1], a[i + 1], a[i + 2]]
  x3 = [0, 6, 18, 24]
  xx3 = 12
  s3 = interpol(y3, x3, xx3, /spline)
  w = [abs(s1 - a[i]), abs(s2 - a[i]), abs(s3 - a[i])]
  m = min(w, sub)
  m = sub
  case m of
       0 : begin
             y = [a[i - 1], a[i]]
             x =[0, 6]
             xx = findgen(6) + 1
             s = [s, interpol(y, x, xx)]
           end
       1 : begin
             y = [a[i - 2], a[i - 1], a[i]]
             x = [0, 6, 12]
             xx = findgen(6) + 7
             s = [s, interpol(y, x, xx, /quadratic)]
           end
       2 : begin
             y = [a[i - 2], a[i - 1], a[i], a[i + 1]] 
             x = [0, 6, 12, 18]
             xx = findgen(6) + 7
             s = [s, interpol(y, x, xx, /spline)]
           end
  endcase
  endfor
  y = [a[n - 3], a[n - 2], a[n - 1]]
  x = [0, 6, 12]
  xx = findgen(12) + 1
  s = [s, interpol(y, x, xx, /quadratic)]
  return, s
end