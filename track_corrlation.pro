;+
; NAME:
;
;    track_corrlation
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
;    The code is aimed at calculating the corrlation betweem the variables in a typhoon track,
;    such as longitude, latitude, MWS, press, c and theta.
;
; CALLING SEQUENCE:
;
; ARGUMENTS:
;
; KEYWORDS:
;
; OUTPUTS:
;
;    a float vector, including the interpolated points in the variable a, every 15min
;
; EXAMPLE:
;
; MODIFICATION_HISTORY:
;

pro track_corrlation

  path = file_search('D:\Tc_track\point01\', '*.shp')  ;读取所有台风的数据
  lon01 = shape_attribute_read(path, 'lon')  ;所有经度的数据
  lat01 = shape_attribute_read(path, 'lat')  ;所有纬度的数据
  ID01 = shape_attribute_read(path, 'Uniq_ID')  ;台风的ID号
  CC01 = shape_attribute_read(path, 'Dual_C')  ;台风是否分叉，0表示为未分叉的
  UTC_Yr01 = shape_attribute_read(path, 'UTC_Yr')
  UTC_Mon01 = shape_attribute_read(path, 'UTC_Mon')
  UTC_Day01 = shape_attribute_read(path, 'UTC_Day')
  UTC_Hr01 = shape_attribute_read(path, 'UTC_Hr')
  Pres01 = shape_attribute_read(path, 'Pres')
  MWS01 = shape_attribute_read(path, 'MWS')
  C01 = shape_attribute_read(path, 'C')
  Theta01 = shape_attribute_read(path, 'Theta')
  n1 = readdata(ID01,CC01)
  n = n_elements(n1)/2
  
  lon = lon01[n1[0, 0]: n1[1, 0]]
  lat = lat01[n1[0, 0]: n1[1, 0]]
  Pres = Pres01[n1[0, 0]: n1[1, 0]]
  MWS = MWS01[n1[0, 0]: n1[1, 0]]
  C = C01[n1[0, 0]: n1[1, 0]]
  Theta = Theta01[n1[0, 0]: n1[1, 0]]
  a12 = (mean(lon *  lat) - mean(lon) * mean(lat)) / sqrt((variance(lon) * variance(lat)))
  a13 = (mean(lon * Pres) - mean(lon) * mean(Pres)) / sqrt((variance(lon) * variance(Pres)))
  a14 = (mean(lon * MWS) - mean(lon) * mean(MWS)) / sqrt((variance(lon) * variance(MWS)))
  a15 = (mean(lon * C) - mean(lon) * mean(C)) / sqrt((variance(lon) * variance(C)))
  a16 = (mean(lon * Theta) - mean(lon) * mean(Theta)) / sqrt((variance(lon) * $
         variance(Theta)))
  a23 = (mean(lat * Pres) - mean(lat) * mean(Pres)) / sqrt((variance(lat) * variance(Pres)))
  a24 = (mean(lat * MWS) - mean(lat) * mean(MWS)) / sqrt((variance(lat) * variance(MWS)))
  a25 = (mean(lat * C) - mean(lat) * mean(C)) / sqrt((variance(lat) * variance(C)))
  a26 = (mean(lat * Theta) - mean(lat) * mean(Theta)) / sqrt((variance(lat) * $
         variance(Theta)))
  a34 = (mean(Pres * MWS) - mean(Pres) * mean(MWS)) / sqrt((variance(Pres) * variance(MWS)))
  a35 = (mean(Pres * C) - mean(Pres) * mean(C)) / sqrt((variance(Pres) * variance(C)))
  a36 = (mean(Pres * Theta) - mean(Pres) * mean(Theta)) / sqrt((variance(Pres) * $
         variance(Theta)))
  a45 = (mean(MWS * C) - mean(MWS) * mean(C)) / sqrt((variance(MWS) * variance(C)))
  a46 = (mean(MWS * Theta) - mean(MWS) * mean(Theta)) / sqrt((variance(MWS) * $
         variance(Theta)))
  a56 = (mean(C * Theta) - mean(C) * mean(Theta)) / sqrt((variance(C) * variance(Theta)))
  
  for k = 0, n - 1 do begin
    lon = lon01[n1[0, k]: n1[1, k]]
    lat = lat01[n1[0, k]: n1[1, k]]
    Pres = Pres01[n1[0, k]: n1[1, k]]
    MWS = MWS01[n1[0, k]: n1[1, k]]
    C = C01[n1[0, k]: n1[1, k]]
    Theta = Theta01[n1[0, k]: n1[1, k]]
    a12 = [[a12], (mean(lon * lat) - mean(lon) * mean(lat)) / sqrt((variance(lon) * $
           variance(lat)))]
    a13 = [[a13], (mean(lon * Pres) - mean(lon) * mean(Pres)) / sqrt((variance(lon) * $
           variance(Pres)))]
    a14 = [[a14], (mean(lon * MWS) - mean(lon) * mean(MWS)) / sqrt((variance(lon) * $
           variance(MWS)))]
    a15 = [[a15], (mean(lon * C) - mean(lon) * mean(C)) / sqrt((variance(lon) * variance(C)))]
    a16 = [[a16], (mean(lon * Theta) - mean(lon) * mean(Theta)) / sqrt((variance(lon) * $
           variance(Theta)))]
    a23 = [[a23], (mean(lat * Pres) - mean(lat) * mean(Pres)) / sqrt((variance(lat) * $
           variance(Pres)))]
    a24 = [[a24], (mean(lat * MWS) - mean(lat) * mean(MWS)) / sqrt((variance(lat) * $
           variance(MWS)))]
    a25 = [[a25], (mean(lat * C) - mean(lat) * mean(C)) / sqrt((variance(lat) * variance(C)))]
    a26 = [[a26], (mean(lat * Theta) - mean(lat) * mean(Theta)) / sqrt((variance(lat) * $
           variance(Theta)))]
    a34 = [[a34], (mean(Pres * MWS) - mean(Pres) * mean(MWS)) / sqrt((variance(Pres) * $
           variance(MWS)))]
    a35 = [[a35], (mean(Pres * C) - mean(Pres) * mean(C)) / sqrt((variance(Pres) * $
           variance(C)))]
    a36 = [[a36], (mean(Pres * Theta) - mean(Pres) * mean(Theta)) / sqrt((variance(Pres) * $
           variance(Theta)))]
    a45 = [[a45], (mean(MWS * C) - mean(MWS) * mean(C)) / sqrt((variance(MWS) * variance(C)))]
    a46 = [[a46], (mean(MWS * Theta) - mean(MWS) * mean(Theta)) / sqrt((variance(MWS) * $
           variance(Theta)))]
    a56 = [[a56], (mean(C * Theta) - mean(C) * mean(Theta)) / sqrt((variance(C) * $
           variance(Theta)))]
  endfor
  
  b = fltarr(2, 15)
  b[ *  , 0]  = [min(a12), max(a12)]
  b[ *  , 1]  = [min(a13), max(a13)]
  b[ *  , 2]  = [min(a14), max(a14)]
  b[ *  , 3]  = [min(a15), max(a15)]
  b[ *  , 4]  = [min(a16), max(a16)]
  b[ *  , 5]  = [min(a23), max(a23)]
  b[ *  , 6]  = [min(a24), max(a24)]
  b[ *  , 7]  = [min(a25), max(a25)]
  b[ *  , 8]  = [min(a26), max(a26)]
  b[ *  , 9]  = [min(a34), max(a34)]
  b[ *  , 10] = [min(a35), max(a35)]
  b[ *  , 11] = [min(a36), max(a36)]
  b[ *  , 12] = [min(a45), max(a45)]
  b[ *  , 13] = [min(a46), max(a46)]
  b[ *  , 14] = [min(a56), max(a56)]
  
  print, b
  
  b1 = fltarr(1, 15)
  b1[0] = (mean(lon01 * lat01) - mean(lon01) * mean(lat01)) / sqrt((variance(lon01) * $
           variance(lat01)))
  b1[1] = (mean(lon01 * Pres01) - mean(lon01) * mean(Pres01)) / sqrt((variance(lon01) * $
           variance(Pres01)))
  b1[2] = (mean(lon01 * MWS01) - mean(lon01) * mean(MWS01)) / sqrt((variance(lon01) * $
           variance(MWS01)))
  b1[3] = (mean(lon01 * C01) - mean(lon01) * mean(C01)) / sqrt((variance(lon01) * $
           variance(C01)))
  b1[4] = (mean(lon01 * Theta01) - mean(lon01) * mean(Theta01)) / sqrt((variance(lon01) * $
           variance(Theta01)))
  b1[5] = (mean(lat01 * Pres01) - mean(lat01) * mean(Pres01)) / sqrt((variance(lat01) * $
           variance(Pres01)))
  b1[6] = (mean(lat01 * MWS01) - mean(lat01) * mean(MWS01)) / sqrt((variance(lat01) * $
           variance(MWS01)))
  b1[7] = (mean(lat01 * C01) - mean(lat01) * mean(C01)) / sqrt((variance(lat01) * $
           variance(C01)))
  b1[8] = (mean(lat01 * Theta01) - mean(lat01) * mean(Theta01)) / sqrt((variance(lat01) * $
           variance(Theta01)))
  b1[9] = (mean(Pres01 * MWS01) - mean(Pres01) * mean(MWS01)) / sqrt((variance(Pres01) * $
           variance(MWS01)))
  b1[10] = (mean(Pres01 * C01) - mean(Pres01) * mean(C01)) / sqrt((variance(Pres01) * $
            variance(C01)))
  b1[11] = (mean(Pres01 * Theta01) - mean(Pres01) * mean(Theta01)) / sqrt((variance(Pres01) * $
            variance(Theta01)))
  b1[12] = (mean(MWS01 * C01) - mean(MWS01) * mean(C01)) / sqrt((variance(MWS01) * $
            variance(C01)))
  b1[13] = (mean(MWS01 * Theta01) - mean(MWS01) * mean(Theta01)) / sqrt((variance(MWS01) * $
            variance(Theta01)))
  b1[14] = (mean(C01 * Theta01) - mean(C01) * mean(Theta01)) / sqrt((variance(C01) * $
             variance(Theta01)))
  
  print, b1
  
end

