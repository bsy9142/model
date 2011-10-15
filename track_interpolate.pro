;+
; NAME:
;
;    tarck_interpolate
;
; AUTHOR:
;
;    Yin yunjian
;    yinyunjian@mail.bnu.edu.cn
;
; PURPOSE:
;
;    The code in aimed at interpolating by different means, including linear, quadratic,
;    spline and a combination of them.
;
;
; CALLING SEQUENCE:
;
;    result = track_interpolate(time_interved, year, month, day, hour, lon, lat, cp = cp, 
;                               MWS = MWS, vt = vt, heading = heading, method)
;
; ARGUMENTS:
;
;    time_interved: a float scalar, the distance between two point in the output
;    year: a float vector, the year of every point in the tropical before interpolating
;    month: a float vector, the month of every point in the tropical before interpolating
;    day: a float vector, the day of every point in the tropical before interpolating
;    hour: a float vector, the hour of every point in the tropical before interpolating
;    lat: a float vector, the latitude of every point in the tropical before interpolating
;    lat: a float vector, the longitude of every point in the tropical before interpolating
;    
;    
;    
;    
;    method: a integer scalar, the interpolting method
; KEYWORDS:
;
; OUTPUTS:
;
;    the variable have changed their vable 
;
; EXAMPLE:
;    year=[2002, 2002, 2002, 2002, 2002]
;    month=[5, 5, 5, 5, 5]
;    day=[18, 18, 18, 19, 19]
;    hour=[6, 12, 18, 0, 6]
;    lon=[139.9, 139.8, 139.7, 139.4, 139.0]
;    lat=[5.7, 5.9, 6.0, 6.2, 6.3]
;    result = track_interpolate(15, year, month, day, hour, lon, lat, 4)
;
; MODIFICATION_HISTORY:
;
;
function track_interpolate, time_interved, year, month, day, hour, lon, lat, cp=cp, MWS = MWS,$
                             vt=vt, heading=heading, method
  n1 = n_elements(year)
  m1 = 0
  for k = 1, n1 - 1 do begin
    m1 = [m1, hour(k) - hour(k - 1)]
    if m1[k] lt 0 then begin
      m1[k] = m1[k] + 24
    endif
    m1[k] = m1[k - 1] + m1[k]
  endfor
  m2 = (findgen(m1[n1 - 1] * 60 / time_interved + 1)) * time_interved / 60
  year1 = year[0]
  month1 = month[0]
  day1 = day[0]
  hour1 = hour[0]
  for i = 1, n1 - 1 do begin
    if hour[i] gt hour[i - 1] then begin
      n2 = hour[i] - hour[i - 1]
      year1 = [year1, year[i] * (intarr(n2 * 60 / time_interved) + 1)]
      month1 = [month1, month[i] * (intarr(n2 * 60 / time_interved) + 1)]
      day1 = [day1, day[i] * (intarr(n2 * 60 / time_interved) + 1)]
      hour1 = [hour1, hour[i - 1] + (findgen(n2 * 60 / time_interved) + 1) * time_interved / $
               60]
    endif else begin
      n2 = hour[i] + 24 - hour[i - 1]
      if (24 - hour[i - 1]) * 60 / time_interved eq 1 then begin
        hour1 = [hour1, findgen(hour[i] * 60 / time_interved + 1) * time_interved / 60]
        day1 = [day1, day[i] * (intarr(hour[i] * 60 / time_interved + 1) + 1)]
      endif else begin
        hour1 = [hour1, hour[i - 1] + (findgen((24 - hour[i - 1]) * 60 / time_interved - 1) $
                  + 1) * time_interved / 60, findgen(hour[i] * 60 / time_interved + 1) * $
                  time_interved / 60]
        day1 = [day1, day[i - 1] * (intarr((24 - hour[i - 1]) * 60 / time_interved - 1) + 1), $
                day[i] * (intarr(hour[i] * 60 / time_interved + 1) + 1)]
      endelse
      if month[i] eq month[i - 1] then begin
        month1 = [month1, month[i] * (intarr(n2 * 60 / time_interved) + 1)]
      endif else begin
        if (24 - hour[i - 1]) * 60 / time_interved eq 1 then begin
          month1 = [month1, month[i] * (intarr(hour[i] * 60 / time_interved + 1) + 1)]
        endif else begin
          month1 = [month1, month[i - 1] * (intarr((24 - hour[i - 1]) * 60 / time_interved $
                    - 1) + 1), month[i] * (intarr(hour[i] * 60 / time_interved + 1) + 1)]
        endelse
      endelse
      if year[i] eq year[i - 1] then begin
        year1 = [year1, year[i] * (intarr(n2 * 60 / time_interved) + 1)]
      endif else begin
        if (24 - hour[i - 1]) * 60 / time_interved eq 1 then begin
          year1 = [year1, year[i] * (intarr(hour[i] * 60 / time_interved + 1) + 1)]
        endif else begin
          year1 = [year1, year[i - 1] * (intarr((24 - hour[i - 1]) * 60 / time_interved $
                   - 1) + 1), year[i] * (intarr(hour[i] * 60 / time_interved + 1) + 1)]
        endelse
      endelse
    endelse
  endfor
  year = year1
  month = month1
  day = day1
  hour = hour1
  case method of
    1 : begin
          lon = interpol(lon, m1, m2)
          lat = interpol(lat, m1, m2)
          if keyword_set(MWS) then begin
            MWS = interpol(MWS, m1, m2)
          endif
          if keyword_set(cp) then begin
            cp = interpol(cp, m1, m2)
          endif
          if keyword_set(vt) then begin
            vt = interpol(vt, m1, m2)
          endif
          if keyword_set(heading) then begin
            sin_heading = interpol(sin(heading * !pi / 180), m1, m2)
            cos_heading = interpol(cos(heading * !pi / 180), m1, m2)
            heading = angle(sin_heading, cos_heading)
          endif
        end
    2 : begin
          lon = interpol(lon, m1, m2, /quadratic)
          lat = interpol(lat, m1, m2, /quadratic)
          if keyword_set(cp) then begin
            cp = interpol(cp, m1, m2, /quadratic)
          endif
          if keyword_set(MWS) then begin
            MWS = interpol(MWS, m1, m2, /quadratic)
          endif
          if keyword_set(vt) then begin
            vt = interpol(vt, m1, m2, /quadratic)
          endif
          if keyword_set(heading) then begin
            sin_heading = interpol(sin(heading * !pi/180), m1, m2, /quadratic)
            cos_heading = interpol(cos(heading * !pi/180), m1, m2, /quadratic)
            heading = angle(sin_heading, cos_heading)
          endif
        end
    3 : begin
          lon = interpol(lon, m1, m2, /spline)
          lat = interpol(lat, m1, m2, /spline)
          if keyword_set(cp) then begin
            cp = interpol(cp, m1, m2, /spline)
          endif
          if keyword_set(MWS) then begin
            MWS = interpol(MWS, m1, m2, /spline)
          endif
          if keyword_set(vt) then begin
            vt = interpol(vt, m1, m2, /spline)
          endif
          if keyword_set(heading) then begin
            sin_heading = interpol(sin(heading * !pi/180), m1, m2, /spline)
            cos_heading = interpol(cos(heading * !pi/180), m1, m2, /spline)
            heading = angle(sin_heading, cos_heading)
          endif
        end
    4 : begin
          lon = track_interpol00(lon, m1, m2)
          lat = track_interpol00(lat, m1, m2)
          if keyword_set(cp) then begin
            cp = track_interpol00(cp, m1, m2)
          endif
          if keyword_set(MWS) then begin
            MWS = track_interpol00(MWS, m1, m2)
          endif
          if keyword_set(vt) then begin
            vt = track_interpol00(vt, m1, m2)
          endif
          if keyword_set(heading) then begin
            sin_heading = track_interpol00(sin(heading * !pi / 180), m1, m2)
            cos_heading = track_interpol00(cos(heading * !pi / 180), m1, m2)
            heading = angle(sin_heading, cos_heading)
          endif
        end
  endcase
  return, 1
end