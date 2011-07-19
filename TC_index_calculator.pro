;+
; NAME:
;
;    TC_index_calculator
;
; AUTHOR:
;
;    Yuguo Wu
;    irisksys@gmail.com
;
; PURPOSE:
;
;    calculator cyclone index

;
; CALLING SEQUENCE:
;
;    result = TC_index_calculator(fn_shape_read_BEST_C, fn_shape_write_BEST_C, $
;      fn_shape_read_BEST_L, fn_shape_write_BEST_L)
;
; ARGUMENTS:
;
;    fn_shape_read: A string of shape file name with full path from which program read
;    TC index parameters.
;    fn_shape_write_BEST_C: A string of BEST_C shape file name with full path to which 
;    program write calculated index.
;    fn_shape_write_BEST_L: A string of BEST_L shape file name with full path to which 
;    program write calculated index.

; KEYWORDS:
;    fld_type: field data type
;    fld_width: field data width
;    fld_precision: field data precision
;
; OUTPUTS:
;
;    1: calculate successfully
;    0: calculaote failed for such reasons:
;      a. shape files don't exist
;      b. fields don't exist
;
; EXAMPLE:
;pro Tc_index_calculator_example
;  root_dir = programrootdir(/oneup)
;  fn_shape_path_in = filepath('',root_dir = root_dir, subdirectory = ['dat'])
;  fn_shape_file_in = file_search(fn_shape_path_in,'*.shp')
;  fn_shape_file_out= filepath(file_basename(fn_shape_file_in,'.shp')$
;    +'_v2.shp',root_dir = root_dir,subdirectory = ['rst'])
;       fld_type = 5
;       fld_width = 10
;       fld_precision = 4
;  result=  TC_index_calculator(fn_shape_file_in,fn_shape_file_out)
;  print,'end of Tc_index_calculator_example.'
;end
;
; MODIFICATION_HISTORY:
;  LI Ying -- Add the keywords;
;          -- Change an value of ＡCE to different values and output modificated BEST_C file.　
;  Yuguo Wu irisksys@gmail.com July 12th
;             Add BEST_L file writing, add PDI calculator
;
function TC_index_calculator, fn_shape_read_BEST_C, fn_shape_write_BEST_C, $
  fn_shape_read_BEST_L, fn_shape_write_BEST_L
  
  ;calculate ACE index
  V = shape_attribute_read(fn_shape_read_BEST_C, 'MWS')
  ACE = fltarr(n_elements(v))
  for int_entity = 0,n_elements(v)-1 do begin
    ACE[int_entity] = TC_index_ACE_get(v[0:int_entity], unit = 1)
  endfor
  PDI = fltarr(n_elements(v))
  for int_entity = 0,n_elements(v)-1 do begin
    PDI[int_entity] = TC_index_PDI_get(v[0:int_entity], unit = 1)
  endfor
  result = shape_attribute_add(fn_shape_read_BEST_C, fn_shape_write_BEST_C, fld_NAME = $
    ['ACE','PDI'], fld_TYPE = [5,5], fld_WIDTH = [10,10], fld_PRECISION = [4,4])
  result = shape_copy(fn_shape_read_BEST_L, fn_shape_write_BEST_L, $
    names_replace = name_replace)
  
  result = shape_attribute_set(fn_shape_write_BEST_C, 'ACE', ACE)
  result = shape_attribute_set(fn_shape_write_BEST_L, 'ACE', ACE[n_elements(V) - 1])
  result = shape_attribute_set(fn_shape_write_BEST_C, 'PDI', PDI)
  result = shape_attribute_set(fn_shape_write_BEST_L, 'PDI', PDI[n_elements(V) - 1])
  return, 1
end