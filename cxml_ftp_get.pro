;+
; NAME:
;
;    cxml_ftp_get
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
;      1. Timer download
;      2. recursively search remoter directory
;      3. lack knowledge of IDL libraries, manually write some algorithm
;
; CALLING SEQUENCE:
;
;    dummy = cxml_ftp_get, ftp_server, remote_dir, remote_file_list = remote_file_list, $ 
;    local_dir = local_dir, time_range = time_range, time_interval = time_interval, time_end
;
; ARGUMENTS:
;
;    cxml_ftp_get: A string vector of ftp server addresses
;    remote_dir: A string vector of remote directory in ftp server
;
; KEYWORDS:
;
;    remote_file_list: A string vector of download files. If it's given, program will download
;    files included in the list; otherwise, it will download all the files in the remote directory
;    local_dir: A string of local disk directory. If it's given, program will download files in it;
;    otherwise, program will download files in the folder of current IDL procedure file.
;    time_range: the starting and ending time for downloading files. if not set, 
;    download files only once by call function ftp_get();otherwise, call ftp_get_timer()
;    time_interval: time interval to check whether new files are available to get from sever. 
;    Only valid if keyword 'time_range is' set 
;
; OUTPUTS:
;
;    1：  Download successfully
;    0: Download failed
;
; EXAMPLE:
;
; MODIFICATION_HISTORY:
;
;    Yuguo Wu, irisksys@gmail.com, July 4th, 2011
;    Finished first version of program. Can operate a download task, without robustness
;    check
;    Yuguo Wu, irisksys@gmail.com, July 6th, 2011
;    Add remote file list selection, divide ftp server and remote dir into two arguments
;    and check ftp server update 
;
function check_update, remote_file_list, get_dir
  ; get all the local directory files
  local_file_list = file_search(get_dir, '*.xml')
  for i_local = 0, n_elements(local_file_list) - 1 do begin
    local_file_list[i_local] = strmid(local_file_list[i_local], strpos(local_file_list[i_local],$
    '\', /REVERSE_SEARCH)+1)
  endfor
  ; remote file list is completely equal to local file list, which means no update in server
  if array_equal(remote_file_list,local_file_list) eq 1 then begin
    return, 1
  endif else begin
  ; list files to be downloaded. Pass existed files
    for i_remote = 0, n_elements(remote_file_list) - 1 do begin
      flag_exist = 0
      for i_local = 0, n_elements(local_file_list) - 1 do begin
        if strcmp(remote_file_list[i_remote], local_file_list[i_local]) eq 1 then begin
          flag_exist = 1
          break
        endif
      endfor
      if flag_exist eq 1 then remote_file_list[i_remote] = 'null'
    endfor
    remote_file_list = remote_file_list[where(strcmp(remote_file_list, 'null') eq 0)]
    return, remote_file_list
  endelse
end

function ftp_get, ftp_server, remote_dir, remote_file_list = remote_file_list, $ 
         local_dir = local_dir
  ; find or build local directory
  if keyword_set(local_dir) then begin
    root_dir = local_dir
    if ~file_test(root_dir) then file_mkdir, root_dir
  endif else begin
    root_dir = FILE_DIRNAME((ROUTINE_INFO('ftp_get', /SOURCE)).PATH)
  endelse
  ; no '\' in the end of given local directory, add it 
  if strcmp(strmid(root_dir, strlen(root_dir)-1), '\') eq 0 then root_dir = root_dir + '\'
  
  ; set ftp properties
  cxml_get = OBJ_NEW('IDLnetUrl')
  for i_url = 0, n_elements(ftp_server) - 1 do begin
    cxml_get->SetProperty, URL_SCHEME = strmid(ftp_server[i_url], 0,$
    strpos(ftp_server[i_url], ':'))
    cxml_get->SetProperty, URL_HOST = strmid(ftp_server[i_url],strpos(ftp_server[i_url], ':')+3)
        
  ; build directory for every ftp server downloading
  ; case 1: ftp server address doesn't contains user:password
    if strpos(ftp_server[i_url], '@') eq -1 then begin
      sub_url = strmid(ftp_server[i_url], strpos(ftp_server[i_url], ':')+3)
      get_dir = root_dir + strmid(sub_url, 0, strpos(sub_url, '/') + 1)
  ; case 2: ftp server address contains user:password information
    endif else begin
      sub_url = strmid(ftp_server[i_url], strpos(ftp_server[i_url], '@')+1)
      get_dir = root_dir + strmid(sub_url, 0, strpos(sub_url, '/') + 1)
    endelse
    if ~file_test(get_dir) then file_mkdir, get_dir
        
  ; set remote download list
    get_list = cxml_get->GetFtpDirList()
    for i_list = 0, n_elements(get_list) - 1 do begin
        get_list[i_list] = strmid(get_list[i_list], strpos(get_list[i_list], ' ', $
        /REVERSE_SEARCH)+1)
    endfor
  ; no remote file list setting, download all the files in the server
    if ~keyword_set(remote_file_list) then begin
      remote_file_list = get_list
  ; remote file list has been set, check the existence in the ftp server
    endif else begin
      for i_list = 0, n_elements(remote_file_list) - 1 do begin
        flag_match = 0
        for i_get_list = 0, n_elements(get_list) - 1 do begin
          if strcmp(remote_file_list[i_list], get_list[i_get_list]) eq 1 then begin
            flag_match = 1
            break
          endif
        endfor
        if flag_match eq 0 then begin
          print, 'File: ' + remote_file_list[i_list] + ' not exists'
          remote_file_list[i_list] = 'null'
        endif
      endfor
      
  ; if none of remote file list exists in the ftp server, function return 0
    flag_none_match = 0
    for i_list = 0, n_elements(remote_file_list) - 1 do begin
      if strcmp(remote_file_list[i_list],'null') eq 0 then begin
        flag_none_match = 1
        break
      endif
    endfor
    if flag_none_match eq 0 then begin
      print, 'No match file in the ftp server'
      OBJ_DESTROY, cxml_get
      return, 0
    endif 
      remote_file_list = remote_file_list[where(strcmp(remote_file_list, 'null') eq 0)] 
    endelse
    
  ; check if ftp server has been update. If hasn't, no need to download;otherwise, list
  ; download files that haven't been downloaded yet
    remote_file_list = check_update(remote_file_list, get_dir)
    if remote_file_list eq 1 then begin
      print, 'ftp server no update'
      continue
    endif
    
  ; download cxml files
    for i_get = 0, n_elements(remote_file_list) - 1 do begin
      cxml_get->SetProperty, URL_PATH = remote_file_list[i_get]
      cxml_file = cxml_get->Get(FILENAME = get_dir + remote_file_list[i_get])
      print, 'downloaded: ', cxml_file
    endfor
  endfor
  OBJ_DESTROY, cxml_get
  return, 1
end

function ftp_get_timer, ftp_server, remote_dir, remote_file_list = remote_file_list, $ 
    local_dir = local_dir, time_range = time_range, time_interval = time_interval
    
end

function cxml_ftp_get, ftp_server, remote_dir, remote_file_list = remote_file_list, $ 
local_dir = local_dir, time_range = time_range, time_interval = time_interval, time_end
  if ~keyword_set(time_range) then begin
    dummy = cxml_ftp_get(ftp_server, remote_dir, remote_file_list = remote_file_list, $ 
            local_dir = local_dir)
  endif else begin
    dummy = ftp_get_timer(ftp_server, remote_dir, remote_file_list = remote_file_list, $ 
    local_dir = local_dir, time_range = time_range, time_interval = time_interval)
  endelse
end