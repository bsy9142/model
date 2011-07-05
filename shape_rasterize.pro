function shape_rasterize, str_shape_File,  $
    pixel_size, $
    str_fldname   = str_fldname, $
    origin   = origin, $
    n_col_row  = n_col_row, $
    sMap_Target= sMap_Target
    
  oShape = OBJ_NEW('IDLffShape',str_shape_File)
  oShape-> GetProperty, ENTITY_TYPE  = ENTITY_TYPE, ATTRIBUTE_INFO = ATTRIBUTE_INFO
  
  has_valid_fld = 0
  if keyword_set(str_fldname) then begin
    subscript_tmp = where (strtrim(ATTRIBUTE_INFO.name,2) eq strtrim(str_fldname,2), count_tmp)
    if count_tmp NE 1 then begin
      print, 'field ' + str_fldname + 'not exists'
    endif else begin
      fld_type = ATTRIBUTE_INFO[subscript_tmp].type
      if fld_type NE 7 then begin
        fld_no   = subscript_tmp[0]
        has_valid_fld = 1
      endif
    endelse
  endif
  
  ;point
  if ENTITY_TYPE eq 1 then begin
    oShape-> GetProperty, N_ENTITIES=N_ENTITIES
    roi_arr   = objarr(N_ENTITIES)
    fld_vals  = make_array( N_ENTITIES, TYPE=fld_type)
    
    for int_ENT = 0 , N_ENTITIES -1 do begin
      ent_tmp  = Shape_obj -> IDLffShape::GetEntity(i)
      fld_vals[int_ENT]  = (*ent_tmp.ATTRIBUTES).(fld_no)
      
      roi_arr[i] = obj_new('IDLanROI')
      if keyword_set(sMap_Target) then begin
        roi_arr[i] -> IDLanROI::Setproperty, $
          data= MAP_PROJ_FORWARD ([ent_tmp.bounds[0],ent_tmp.bounds[1]], $
          MAP_STRUCTURE = sMap_Target)
      endif else begin
        roi_arr[i] -> IDLanROI::Setproperty, $
          data = [ent_tmp.bounds[0],ent_tmp.bounds[1]]
      endelse
      Shape_obj->IDLffShape::DestroyEntity, ent_tmp ;clean up pointers
      
      roi_arr[i] -> IDLanROI::Getproperty,ROI_XRANGE = x_range_albers
      roi_arr[i] -> IDLanROI::Getproperty,ROI_YRANGE = y_range_albers
      
      if int_ENT eq 0 then begin
        x_min_shp = x_range_albers[0]
        x_max_shp = x_range_albers[1]
        y_min_shp = y_range_albers[0]
        y_max_shp = y_range_albers[1]
      endif else begin
        x_min_shp  = x_min_shp  < x_range_albers[0]
        x_max_shp  = x_max_shp  > x_range_albers[1]
        y_min_shp  = y_min_shp  < y_range_albers[0]
        y_max_shp  = y_max_shp  > y_range_albers[1]
      endelse
      
    endfor ;int_ENT
    
    if ~keyword_set(origin) then begin
      origin    = fltarr(2)
      origin[0] = x_min_shp
      origin[1] = y_min_shp
    endif
    
    if ~keyword_set(n_col_row) then begin
      n_col_row = lonarr(2)
      n_col_row [0] = ceil( (x_max_shp - origin[0])/pixel_size)
      n_col_row [1] = ceil( (y_max_shp - origin[1])/pixel_size)
    endif
    upper_bounds    = dblarr(2)
    upper_bounds[0] = x_min_shp + pixel_size * n_col_row[0]
    upper_bounds[1] = y_min_shp + pixel_size * n_col_row[1]
    
    mask = make_array( n_col_row[0], n_col_row[1], TYPE =fld_type)
    
    for i = 0,n_elements(roi_arr)-1 do begin
    
      roi_arr[i] -> IDLanROI::Getproperty,ROI_XRANGE = x_range_albers
      roi_arr[i] -> IDLanROI::Getproperty,ROI_YRANGE = y_range_albers
      s_tmp = ROUND( double (x_range_albers[0] - origin[0]        ) / pixel_size, /L64)
      l_tmp = ROUND( double (upper_bounds[1]   - y_range_albers[0]) / pixel_size, /L64)
      
      if has_valid_fld then begin
        mask[s_tmp,l_tmp] = fld_vals [i]
      endif else begin
        mask[s_tmp,l_tmp] = i + 1
      endelse
    endfor
    
  endif
  
  ;polygon or polyline
  if ENTITY_TYPE eq 5 or ENTITY_TYPE eq 3 then begin
    ;get the bounds of shapefile
    oShape-> GetProperty, N_ENTITIES=N_ENTITIES
    fld_vals  = make_array( N_ENTITIES, TYPE=fld_type)
    
    ;n_ent = N_ENTITIES
    for int_ENT = 0 , N_ENTITIES -1 do begin
      oENTITY  = oShape -> IDLffShape::GetEntity(int_ENT,/ATTRIBUTES)

      if has_valid_fld eq 1 then begin
        fld_vals[int_ENT] = (*oENTITY.ATTRIBUTES).(fld_no)
      endif else begin
        fld_vals[int_ENT] = int_ENT + 1
      endelse
      
      
      if keyword_set(sMap_Target) then begin
        VERTICES_Polygon_Proj = MAP_PROJ_FORWARD ($
          (*(oENTITY.VERTICES))[0:1,*],$
          MAP_STRUCTURE = sMap_Target)
      endif else begin
        VERTICES_Polygon_Proj = (*(oENTITY.VERTICES))[0:1,*]
      endelse
      PTR_FREE, oENTITY.VERTICES
      oShape->IDLffShape::DestroyEntity, oENTITY
      
      if int_ENT eq 0 then begin
        x_min_shp = min(VERTICES_Polygon_Proj[0,*])
        x_max_shp = max(VERTICES_Polygon_Proj[0,*])
        
        y_min_shp = min(VERTICES_Polygon_Proj[1,*])
        y_max_shp = max(VERTICES_Polygon_Proj[1,*])
      endif else begin
        x_min_shp  = x_min_shp  < min(VERTICES_Polygon_Proj[0,*])
        x_max_shp  = x_max_shp  > max(VERTICES_Polygon_Proj[0,*])
        
        y_min_shp  = y_min_shp  < min(VERTICES_Polygon_Proj[1,*])
        y_max_shp  = y_max_shp  > max(VERTICES_Polygon_Proj[1,*])
      endelse
    endfor
    
    if Keyword_set(origin) then begin
      x_min_shp = origin  [0]
      y_min_shp = origin  [1]
    endif
    
    if ~Keyword_set(n_col_row) then begin
      n_col_row = lonarr(2)
      n_col_row [0] = ceil( (x_max_shp - x_min_shp)/pixel_size)
      n_col_row [1] = ceil( (y_max_shp - y_min_shp)/pixel_size)
    endif
    
    x_max_shp = x_min_shp + pixel_size * n_col_row[0]
    y_max_shp = y_min_shp + pixel_size * n_col_row[1]
    
    if ~Keyword_set(origin) then begin
      origin    = fltarr(2)
      origin[0] = x_min_shp
      origin[1] = y_min_shp
    endif
    
    
    mask = intarr (n_col_row[0],n_col_row[1])
    
    if ENTITY_TYPE eq 3 then begin
      oROI = OBJ_NEW( 'IDLanROI',type=1)
    endif else begin
      oROI = OBJ_NEW( 'IDLanROI')
    endelse
    
    for int_ENT =  0L , N_ENTITIES -1 do begin
    
      oENTITY  = oShape -> IDLffShape::GetEntity(int_ENT)
      
      for int_part = 1L, oENTITY.N_PARTS do begin
      
        if oENTITY.N_PARTS LE 1 then begin
          start_vertic = 0
          end_vertic   = oENTITY.N_VERTICES -1
        endif else begin
          start_vertic = (*oENTITY.Parts)[int_part -1]
          if int_part LT oENTITY.N_PARTS then begin
            end_vertic   = (*oENTITY.Parts)[int_part] -1
          endif else begin
            end_vertic   =  oENTITY.N_VERTICES -1
          endelse
        endelse
        
        
        VERTICES_Polygon_LL = (*oENTITY.vertices)[0:1,start_vertic:end_vertic]
        
        if keyword_set(sMap_Target) then begin
          VERTICES_Polygon_Proj = MAP_PROJ_FORWARD (VERTICES_Polygon_LL[0:1,*], $
            MAP_STRUCTURE = sMap_Target)
        endif else begin
          VERTICES_Polygon_Proj = VERTICES_Polygon_LL[0:1,*]
        endelse
        
        
        ;Compute the columns and rows of the rectangle
        
        ;------------------- revised part 1
        col_left  = floor((min(VERTICES_Polygon_Proj[0,*]) - x_min_shp)$
          /pixel_size,/L64); + 1
        row_down  = floor((min(VERTICES_Polygon_Proj[1,*]) - y_min_shp)$
          /pixel_size,/L64); + 1
          
        x_col_left  = x_min_shp + col_left *pixel_size
        y_row_down  = y_min_shp + row_down *pixel_size
        
        samples_polygon   = ceil((max(VERTICES_Polygon_Proj[0,*]) - $
          x_col_left)/pixel_size,/L64)
        lines_polygon     = ceil((max(VERTICES_Polygon_Proj[1,*]) - $
          y_row_down)/pixel_size,/L64)
        samples_polygon = samples_polygon > 1
        lines_polygon = lines_polygon > 1
        
        VERTICES_Polygon_Proj_aoi = VERTICES_Polygon_Proj / float(pixel_size)
        x_col_left_roi  = x_col_left/float(pixel_size)
        y_row_down_roi  = y_row_down/float(pixel_size)
        
        oROI -> SetProperty, data = VERTICES_Polygon_Proj_aoi [0:1, *]
        
        mask_tmp = oROI->ComputeMask(Dimensions =[samples_polygon,lines_polygon], $
          origin = [x_col_left_roi, y_row_down_roi], $
          mask_rule = 2, $
          PIXEL_CENTER = [0.5,0.5])
          
        case size(mask_tmp, /N_DIMENSIONS) of
          0: ; do nothing
          1: mask_tmp = reverse( mask_tmp /byte(255) )
          2: BEGIN
            mask_tmp = reverse( mask_tmp /byte(255) ,2)
          END
          else: ; never happens
        endcase
        
        col_start = col_left
        col_end   = col_start + samples_polygon - 1
        row_end   = n_col_row[1] - row_down - 1
        row_start = row_end   - lines_polygon + 1
        mask_tmp_col_start = 0
        mask_tmp_col_end = samples_polygon-1
        mask_tmp_row_start = 0
        mask_tmp_row_end = lines_polygon-1
        
        if col_start lt 0 then begin
          mask_tmp_col_start = - col_start
          col_start = 0
        endif
        if col_end ge n_col_row[0] then begin
          mask_tmp_col_end = mask_tmp_col_end - col_end + n_col_row[0]-1
          col_end = n_col_row[0]-1
        endif
        if row_start lt 0 then begin
          mask_tmp_row_start = - row_start
          row_start = 0
        endif
        if row_end ge n_col_row[1] then begin
          mask_tmp_row_end = mask_tmp_row_end - row_end + n_col_row[1]-1
          row_end = n_col_row[1]-1
        endif
        
        mask_tmp = mask_tmp[mask_tmp_col_start:mask_tmp_col_end,mask_tmp_row_start:mask_tmp_row_end]
        
        mask_rst = mask[col_start:col_end,row_start:row_end]
        subscript_tmp = where (mask_rst Eq 0, count_tmp)
        if count_tmp GT 0 then begin
          if keyword_set(str_fldname) then begin
            mask_tmp  = mask_tmp * (fld_vals(int_ENT))
          endif else begin
            mask_tmp  = mask_tmp * (int_ENT+1)
          endelse
          mask_rst [subscript_tmp] = mask_tmp [subscript_tmp]
          mask[col_start:col_end,row_start:row_end] = mask_rst [*,*]
        endif

      endfor ; of int_part
      
      PTR_FREE, oENTITY.PARTS
      PTR_FREE, oENTITY.VERTICES
      oShape->IDLffShape::DestroyEntity, oENTITY
      
    endfor ; of int_ENT
    OBJ_DESTROY, oROI
  endif
  
  oShape->IDLffShape::Close
  OBJ_DESTROY, oShape
  
  print, 'end of rasterize_shape_polygon'
  return, mask
  
end
