;+
; NAME:
;
;    cxml_ftp_download
;
; AUTHOR:
;
;    Yuguo Wu
;    irisksys@gmail.com
;
; PURPOSE:
;
;    Download cxml files from ftp website
;    function to improve:
;      1. Timing downloading
;      2. Check if there is update in remote ftp server.If no, program will return; otherwise, 
;      program runs
;      3. Deal with connection error
;
;
; CALLING SEQUENCE:
;
;    result = cxml_ftp_download, url, local_directory = local_directory, timing = timing
;
; ARGUMENTS:
;
;    url: A string vector of ftp addresses which contain cxml data
;
; KEYWORDS:
;
;    local_directory: A string of local disk directory that store downloaded cxml files. 
;    default is the directory of current procedure file
;    timing: A float variable of regularly downloading time setting. Unit is hour. Default is 1
;
; OUTPUTS:
;
;    1：  Download successfully
;    0: Download failed because the ftp server doesn't exit or response
;
; EXAMPLE:
;
; MODIFICATION_HISTORY:
;
;
function cxml_ftp_download, url, local_directory = local_directory, timing = timing
  if keyword_set(local_directory) then begin
    if file_test(local_directory) then file_mkdir, local_directory
    root_dir = local_directory 
  endif else root_dir = ROUTINE_FILEPATH('cxml_ftp_download')

  cxml_down = OBJ_NEW('IDLnetUrl')
  for i_url = 0, n_elements(url)-1 do begin
    cxml_down->SetProperty, URL_SCHEME = strmid(url[i_url], 0, strpos(url[i_url], ':'))
    cxml_down->SetProperty, URL_HOST = strmid(url[i_url],strpos(url[i_url], ':')+3)
    if strpos(url[i_url], '@') eq -1 then begin
      sub_url = strmid(url[i_url], strpos(url[i_url], ':')+3)
      file_mkdir, root_dir + strmid(sub_url, 0, strpos(sub_url, '/'))
    endif else begin
      sub_url = strmid(url[i_url], strpos(url[i_url], '@')+1)
      file_mkdir, root_dir + strmid(sub_url, 0, strpos(sub_url, '/'))
    endelse
    root_dir = root_dir + strmid(sub_url, 0, strpos(sub_url, '/')+1)
    download_list = cxml_down->GetFtpDirList()
    for i_list = 0, n_elements(download_list)-1 do begin
      down_path = strmid(download_list[i_list], strpos(download_list[i_list], ' ', $
      /REVERSE_SEARCH)+1)
      cxml_down->SetProperty, URL_PATH = down_path
      cxml_file = cxml_down->Get(FILENAME = root_dir + down_path)
      print, 'downloading: ', cxml_file
    endfor
  endfor
  return, 1
 end 
