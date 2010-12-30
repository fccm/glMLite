
open GL ;;

module Gl = struct
  let enable cap =
    let cap = match cap with
    |`alpha_test           -> GL_ALPHA_TEST
    |`auto_normal          -> GL_AUTO_NORMAL
    |`blend                -> GL_BLEND
    |`clip_plane0          -> GL_CLIP_PLANE0
    |`clip_plane1          -> GL_CLIP_PLANE1
    |`clip_plane2          -> GL_CLIP_PLANE2
    |`clip_plane3          -> GL_CLIP_PLANE3
    |`clip_plane4          -> GL_CLIP_PLANE4
    |`clip_plane5          -> GL_CLIP_PLANE5
    |`color_material       -> GL_COLOR_MATERIAL
    |`cull_face            -> GL_CULL_FACE
    |`depth_test           -> GL_DEPTH_TEST
    |`dither               -> GL_DITHER
    |`fog                  -> GL_FOG
    |`light0               -> GL_LIGHT0
    |`light1               -> GL_LIGHT1
    |`light2               -> GL_LIGHT2
    |`light3               -> GL_LIGHT3
    |`light4               -> GL_LIGHT4
    |`light5               -> GL_LIGHT5
    |`light6               -> GL_LIGHT6
    |`light7               -> GL_LIGHT7
    |`lighting             -> GL_LIGHTING
    |`line_smooth          -> GL_LINE_SMOOTH
    |`line_stipple         -> GL_LINE_STIPPLE
    |`index_logic_op       -> GL_INDEX_LOGIC_OP
    |`color_logic_op       -> GL_COLOR_LOGIC_OP
    |`map1_color_4         -> GL_MAP1_COLOR_4
    |`map1_index           -> GL_MAP1_INDEX
    |`map1_normal          -> GL_MAP1_NORMAL
    |`map1_texture_coord_1 -> GL_MAP1_TEXTURE_COORD_1
    |`map1_texture_coord_2 -> GL_MAP1_TEXTURE_COORD_2
    |`map1_texture_coord_3 -> GL_MAP1_TEXTURE_COORD_3
    |`map1_texture_coord_4 -> GL_MAP1_TEXTURE_COORD_4
    |`map1_vertex_3        -> GL_MAP1_VERTEX_3
    |`map1_vertex_4        -> GL_MAP1_VERTEX_4
    |`map2_color_4         -> GL_MAP2_COLOR_4
    |`map2_index           -> GL_MAP2_INDEX
    |`map2_normal          -> GL_MAP2_NORMAL
    |`map2_texture_coord_1 -> GL_MAP2_TEXTURE_COORD_1
    |`map2_texture_coord_2 -> GL_MAP2_TEXTURE_COORD_2
    |`map2_texture_coord_3 -> GL_MAP2_TEXTURE_COORD_3
    |`map2_texture_coord_4 -> GL_MAP2_TEXTURE_COORD_4
    |`map2_vertex_3        -> GL_MAP2_VERTEX_3
    |`map2_vertex_4        -> GL_MAP2_VERTEX_4
    |`normalize            -> GL_NORMALIZE
    |`point_smooth         -> GL_POINT_SMOOTH
    |`polygon_smooth       -> GL_POLYGON_SMOOTH
    |`polygon_stipple      -> GL_POLYGON_STIPPLE
    |`scissor_test         -> GL_SCISSOR_TEST
    |`stencil_test         -> GL_STENCIL_TEST
    |`texture_1d           -> GL_TEXTURE_1D
    |`texture_2d           -> GL_TEXTURE_2D
                        (* -> GL_TEXTURE_3D *)
    |`texture_gen_q        -> GL_TEXTURE_GEN_Q
    |`texture_gen_r        -> GL_TEXTURE_GEN_R
    |`texture_gen_s        -> GL_TEXTURE_GEN_S
    |`texture_gen_t        -> GL_TEXTURE_GEN_T
                        (*
                           -> GL_COLOR_TABLE
                           -> GL_CONVOLUTION_1D
                           -> GL_CONVOLUTION_2D
                           -> GL_HISTOGRAM
                           -> GL_MINMAX
                           -> GL_POLYGON_OFFSET_FILL
                           -> GL_POLYGON_OFFSET_LINE
                           -> GL_POLYGON_OFFSET_POINT
                           -> GL_POST_COLOR_MATRIX_COLOR_TABLE
                           -> GL_POST_CONVOLUTION_COLOR_TABLE
                           -> GL_RESCALE_NORMAL
                           -> GL_SEPARABLE_2D
                        *)
    in
    glEnable ~cap ;;

  let disable cap =
    let cap = match cap with
    |`alpha_test           -> GL_ALPHA_TEST
    |`auto_normal          -> GL_AUTO_NORMAL
    |`blend                -> GL_BLEND
    |`clip_plane0          -> GL_CLIP_PLANE0
    |`clip_plane1          -> GL_CLIP_PLANE1
    |`clip_plane2          -> GL_CLIP_PLANE2
    |`clip_plane3          -> GL_CLIP_PLANE3
    |`clip_plane4          -> GL_CLIP_PLANE4
    |`clip_plane5          -> GL_CLIP_PLANE5
    |`color_material       -> GL_COLOR_MATERIAL
    |`cull_face            -> GL_CULL_FACE
    |`depth_test           -> GL_DEPTH_TEST
    |`dither               -> GL_DITHER
    |`fog                  -> GL_FOG
    |`light0               -> GL_LIGHT0
    |`light1               -> GL_LIGHT1
    |`light2               -> GL_LIGHT2
    |`light3               -> GL_LIGHT3
    |`light4               -> GL_LIGHT4
    |`light5               -> GL_LIGHT5
    |`light6               -> GL_LIGHT6
    |`light7               -> GL_LIGHT7
    |`lighting             -> GL_LIGHTING
    |`line_smooth          -> GL_LINE_SMOOTH
    |`line_stipple         -> GL_LINE_STIPPLE
    |`index_logic_op       -> GL_INDEX_LOGIC_OP
    |`color_logic_op       -> GL_COLOR_LOGIC_OP
    |`map1_color_4         -> GL_MAP1_COLOR_4
    |`map1_index           -> GL_MAP1_INDEX
    |`map1_normal          -> GL_MAP1_NORMAL
    |`map1_texture_coord_1 -> GL_MAP1_TEXTURE_COORD_1
    |`map1_texture_coord_2 -> GL_MAP1_TEXTURE_COORD_2
    |`map1_texture_coord_3 -> GL_MAP1_TEXTURE_COORD_3
    |`map1_texture_coord_4 -> GL_MAP1_TEXTURE_COORD_4
    |`map1_vertex_3        -> GL_MAP1_VERTEX_3
    |`map1_vertex_4        -> GL_MAP1_VERTEX_4
    |`map2_color_4         -> GL_MAP2_COLOR_4
    |`map2_index           -> GL_MAP2_INDEX
    |`map2_normal          -> GL_MAP2_NORMAL
    |`map2_texture_coord_1 -> GL_MAP2_TEXTURE_COORD_1
    |`map2_texture_coord_2 -> GL_MAP2_TEXTURE_COORD_2
    |`map2_texture_coord_3 -> GL_MAP2_TEXTURE_COORD_3
    |`map2_texture_coord_4 -> GL_MAP2_TEXTURE_COORD_4
    |`map2_vertex_3        -> GL_MAP2_VERTEX_3
    |`map2_vertex_4        -> GL_MAP2_VERTEX_4
    |`normalize            -> GL_NORMALIZE
    |`point_smooth         -> GL_POINT_SMOOTH
    |`polygon_smooth       -> GL_POLYGON_SMOOTH
    |`polygon_stipple      -> GL_POLYGON_STIPPLE
    |`scissor_test         -> GL_SCISSOR_TEST
    |`stencil_test         -> GL_STENCIL_TEST
    |`texture_1d           -> GL_TEXTURE_1D
    |`texture_2d           -> GL_TEXTURE_2D
                        (* -> GL_TEXTURE_3D *)
    |`texture_gen_q        -> GL_TEXTURE_GEN_Q
    |`texture_gen_r        -> GL_TEXTURE_GEN_R
    |`texture_gen_s        -> GL_TEXTURE_GEN_S
    |`texture_gen_t        -> GL_TEXTURE_GEN_T
                        (*
                           -> GL_COLOR_TABLE
                           -> GL_CONVOLUTION_1D
                           -> GL_CONVOLUTION_2D
                           -> GL_HISTOGRAM
                           -> GL_MINMAX
                           -> GL_POLYGON_OFFSET_FILL
                           -> GL_POLYGON_OFFSET_LINE
                           -> GL_POLYGON_OFFSET_POINT
                           -> GL_POST_COLOR_MATRIX_COLOR_TABLE
                           -> GL_POST_CONVOLUTION_COLOR_TABLE
                           -> GL_RESCALE_NORMAL
                           -> GL_SEPARABLE_2D
                        *)
    in
    glDisable ~cap ;;

  let flush = glFlush ;;
  let finish = glFinish ;;

end


module GlDraw = struct
  let viewport ~x ~y ~w ~h = glViewport ~x ~y ~width:w ~height:h ;;
  let shade_model = function
    | `flat ->   glShadeModel GL_FLAT
    | `smooth -> glShadeModel GL_SMOOTH ;;
  let color ?(alpha=1.) (r, g, b) = glColor4 ~r ~g ~b ~a:alpha ;;

  let normal ?(x=0.) ?(y=0.) ?(z=0.) () = glNormal3 ~nx:x ~ny:y ~nz:z ;;
  let normal3 v = glNormal3v ~v ;;

  let point_size size = glPointSize ~size ;;
  let line_width width = glLineWidth ~width ;;

  type shape =
    [`line_loop|`line_strip|`lines|`points|`polygon|`quad_strip|`quads
    |`triangle_fan|`triangle_strip|`triangles]

  let begins shape =
    glBegin ~primitive:(match shape with
    | `points         -> GL_POINTS
    | `lines          -> GL_LINES
    | `polygon        -> GL_POLYGON
    | `triangles      -> GL_TRIANGLES
    | `quads          -> GL_QUADS
    | `line_strip     -> GL_LINE_STRIP
    | `line_loop      -> GL_LINE_LOOP
    | `triangle_strip -> GL_TRIANGLE_STRIP
    | `triangle_fan   -> GL_TRIANGLE_FAN
    | `quad_strip     -> GL_QUAD_STRIP) ;;

  let ends = glEnd ;;
  let index = glIndex ;;

  let vertex ~x ~y ?(z=0.) ?(w=1.) () = glVertex4 ~x ~y ~z ~w ;;
  let vertex2 v = glVertex2v v ;;
  let vertex3 v = glVertex3v v ;;
  let vertex4 v = glVertex4v v ;;

  let polygon_mode ~face mode =
    let mode = match mode with
    | `fill  -> GL_FILL
    | `line  -> GL_LINE
    | `point -> GL_POINT
    in
    let face = match face with
    | `front -> GL_FRONT
    | `both  -> GL_BACK
    | `back  -> GL_FRONT_AND_BACK
    in
    glPolygonMode ~face ~mode ;;

  let cull_face face =
    let mode = match face with
    | `front -> GL_FRONT
    | `both  -> GL_BACK
    | `back  -> GL_FRONT_AND_BACK
    in
    glCullFace ~mode ;;

  let front_face orient =
    glFrontFace ~orientation:(match orient with `ccw -> GL_CCW | `cw -> GL_CW) ;;

  let rect (x1,y1) (x2,y2) = glRect ~x1 ~y1 ~x2 ~y2 ;;

  let edge_flag flag = glEdgeFlag ~flag ;;

  let line_stipple ?(factor=1) pattern = glLineStipple ~factor ~pattern ;;

  let polygon_offset ~factor ~units = glPolygonOffset ~factor ~units ;;

(* TODO
val polygon_stipple : GlPix.bitmap -> unit
*)
end


module GlClear = struct
  let color ?(alpha=1.) (r, g, b) = glClearColor ~r ~g ~b ~a:alpha ;;
  let index c = glClearIndex c ;;
  let depth depth = glClearDepth ~depth ;;
  let clear buf =
    let rec aux acc = function
      | `color   :: buf -> aux (GL_COLOR_BUFFER_BIT  ::acc) buf
      | `depth   :: buf -> aux (GL_DEPTH_BUFFER_BIT  ::acc) buf
      | `accum   :: buf -> aux (GL_ACCUM_BUFFER_BIT  ::acc) buf
      | `stencil :: buf -> aux (GL_STENCIL_BUFFER_BIT::acc) buf
      | [] -> acc
    in
    glClear ~mask:(aux [] buf)
  ;;

  let stencil s = glClearStencil ~s ;;
  let accum ?(alpha=1.) (r, g, b) = glClearAccum r g b alpha ;;
end
(* complete with 1.03 *)


module GlFunc = struct

  let depth_func cmp_func =
    let func = match cmp_func with
    | `always   -> GL_ALWAYS
    | `equal    -> GL_EQUAL
    | `gequal   -> GL_GEQUAL
    | `greater  -> GL_GREATER
    | `lequal   -> GL_LEQUAL
    | `less     -> GL_LESS
    | `never    -> GL_NEVER
    | `notequal -> GL_NOTEQUAL
    in
    glDepthFunc ~func ;;

  let alpha_func cmp_func ~ref =
    let func = match cmp_func with
    | `always   -> GL_ALWAYS
    | `equal    -> GL_EQUAL
    | `gequal   -> GL_GEQUAL
    | `greater  -> GL_GREATER
    | `lequal   -> GL_LEQUAL
    | `less     -> GL_LESS
    | `never    -> GL_NEVER
    | `notequal -> GL_NOTEQUAL
    in
    glAlphaFunc ~func ~ref ;;

  let stencil_func cmp_func ~ref ~mask =
    let func = match cmp_func with
    | `always   -> GL_ALWAYS
    | `equal    -> GL_EQUAL
    | `gequal   -> GL_GEQUAL
    | `greater  -> GL_GREATER
    | `lequal   -> GL_LEQUAL
    | `less     -> GL_LESS
    | `never    -> GL_NEVER
    | `notequal -> GL_NOTEQUAL
    in
    glStencilFunc ~func ~ref ~mask ;;

  let blend_func ~src ~dst =
    glBlendFunc
      ~sfactor:(match src with
          | `zero                -> Sfactor.GL_ZERO
          | `one                 -> Sfactor.GL_ONE
          | `dst_color           -> Sfactor.GL_DST_COLOR
          | `one_minus_dst_color -> Sfactor.GL_ONE_MINUS_DST_COLOR
          | `src_alpha           -> Sfactor.GL_SRC_ALPHA
          | `one_minus_src_alpha -> Sfactor.GL_ONE_MINUS_SRC_ALPHA
          | `dst_alpha           -> Sfactor.GL_DST_ALPHA
          | `one_minus_dst_alpha -> Sfactor.GL_ONE_MINUS_DST_ALPHA
          | `src_alpha_saturate  -> Sfactor.GL_SRC_ALPHA_SATURATE)
      ~dfactor:(match dst with
          | `zero                -> Dfactor.GL_ZERO
          | `one                 -> Dfactor.GL_ONE
          | `src_color           -> Dfactor.GL_SRC_COLOR
          | `one_minus_src_color -> Dfactor.GL_ONE_MINUS_SRC_COLOR
          | `src_alpha           -> Dfactor.GL_SRC_ALPHA
          | `one_minus_src_alpha -> Dfactor.GL_ONE_MINUS_SRC_ALPHA
          | `dst_alpha           -> Dfactor.GL_DST_ALPHA
          | `one_minus_dst_alpha -> Dfactor.GL_ONE_MINUS_DST_ALPHA) ;;
end


module GlMat = struct
  let load_identity () = glLoadIdentity () ;;
  let mode = function
    | `modelview  -> glMatrixMode ~mode:GL_MODELVIEW
    | `projection -> glMatrixMode ~mode:GL_PROJECTION
    | `texture    -> glMatrixMode ~mode:GL_TEXTURE
 (* | `color      -> glMatrixMode ~mode:GL_COLOR *)
  ;;

  let mult mat = glMultMatrix ~mat ;;
  let of_array m = m ;;

  let pop () = glPopMatrix() ;;
  let push () = glPushMatrix() ;;

  let translate3 (x,y,z) = glTranslate ~x ~y ~z ;;
  let translate ?(x=0.) ?(y=0.) ?(z=0.) () = glTranslate ~x ~y ~z ;;

  let scale3 (x,y,z) = glScale ~x ~y ~z ;;
  let scale ?(x=0.) ?(y=0.) ?(z=0.) () = glScale ~x ~y ~z ;;

  let rotate3 ~angle (x,y,z) = glRotate ~angle ~x ~y ~z ;;
  let rotate ~angle ?(x=0.) ?(y=0.) ?(z=0.) () = glRotate ~angle ~x ~y ~z ;;

  let ortho ~x:(left, right) ~y:(bottom, top) ~z:(near, far) =
    glOrtho ~left ~right ~bottom ~top ~near ~far ;;

  let frustum ~x:(left, right) ~y:(bottom, top) ~z:(near, far) =
    glFrustum ~left ~right ~bottom ~top ~near ~far ;;

  let get_matrix m =
    let m_type = match m with
    | `modelview_matrix  -> Get.GL_MODELVIEW_MATRIX
    | `projection_matrix -> Get.GL_PROJECTION_MATRIX
    | `texture_matrix    -> Get.GL_TEXTURE_MATRIX
                         (*
                         -> Get.GL_COLOR_MATRIX
                         -> Get.GL_TRANSPOSE_COLOR_MATRIX
                         -> Get.GL_TRANSPOSE_MODELVIEW_MATRIX
                         -> Get.GL_TRANSPOSE_PROJECTION_MATRIX
                         -> Get.GL_TRANSPOSE_TEXTURE_MATRIX
                         *)
    in
    glGetMatrix m_type ;;
end


module GlLight = struct

  let color_material ~face color_material =
    let mode = match color_material with
    | `emission -> GL_EMISSION
    | `ambient ->  GL_AMBIENT
    | `diffuse ->  GL_DIFFUSE
    | `specular -> GL_SPECULAR
    | `ambient_and_diffuse -> GL_AMBIENT_AND_DIFFUSE
    in
    let face = match face with
    | `front -> GL_FRONT
    | `both  -> GL_BACK
    | `back  -> GL_FRONT_AND_BACK
    in
    glColorMaterial ~face ~mode ;;


  let fog fog_param =
    let p = match fog_param with
    | `mode `linear -> GL_FOG_MODE  GL_LINEAR
    | `mode `exp    -> GL_FOG_MODE  GL_EXP
    | `mode `exp2   -> GL_FOG_MODE  GL_EXP2
    | `density p -> GL_FOG_DENSITY p
    | `start p   -> GL_FOG_START p
    | `End p     -> GL_FOG_END p
    | `index p   -> GL_FOG_INDEX p
    | `color rgba  -> GL_FOG_COLOR rgba
                (* -> GL_FOG_COORD_SRC  GL_FOG_COORD      *)
                (* -> GL_FOG_COORD_SRC  GL_FRAGMENT_DEPTH *)
    in
    glFog p ;;


  let light ~num light_param =
    let p = match light_param with
    | `ambient (r,g,b,a)  -> Light.GL_AMBIENT (r,g,b,a)
    | `diffuse (r,g,b,a)  -> Light.GL_DIFFUSE (r,g,b,a)
    | `specular (r,g,b,a) -> Light.GL_SPECULAR (r,g,b,a)
    | `position point4    -> Light.GL_POSITION point4
    | `spot_direction point3   -> Light.GL_SPOT_DIRECTION point3
    | `spot_exponent p         -> Light.GL_SPOT_EXPONENT p
    | `spot_cutoff p           -> Light.GL_SPOT_CUTOFF p
    | `constant_attenuation p  -> Light.GL_CONSTANT_ATTENUATION p
    | `linear_attenuation p    -> Light.GL_LINEAR_ATTENUATION p
    | `quadratic_attenuation p -> Light.GL_QUADRATIC_ATTENUATION p
    in
    glLight (GL_LIGHT num) p ;;


  let light_model p =
    let light_model = match p with
    | `ambient (r,g,b,a) -> GL_LIGHT_MODEL_AMBIENT (r,g,b,a)
    | `local_viewer p -> GL_LIGHT_MODEL_LOCAL_VIEWER p
    | `two_side p     -> GL_LIGHT_MODEL_TWO_SIDE p
    | `color_control `separate_specular_color -> GL_LIGHT_MODEL_COLOR_CONTROL  GL_SEPARATE_SPECULAR_COLOR
    | `color_control `single_color ->            GL_LIGHT_MODEL_COLOR_CONTROL  GL_SINGLE_COLOR
    in
    glLightModel ~light_model ;;


  let material ~face material_param =
    let mode = match material_param with
    | `ambient (r,g,b,a)    -> Material.GL_AMBIENT (r,g,b,a)
    | `diffuse (r,g,b,a)    -> Material.GL_DIFFUSE (r,g,b,a)
    | `specular (r,g,b,a)   -> Material.GL_SPECULAR (r,g,b,a)
    | `emission (r,g,b,a)   -> Material.GL_EMISSION (r,g,b,a)
    | `shininess (spec_exp) -> Material.GL_SHININESS (spec_exp)
    | `ambient_and_diffuse (r,g,b,a) -> Material.GL_AMBIENT_AND_DIFFUSE (r,g,b,a)
    | `color_indexes (ambient, diffuse, specular) -> Material.GL_COLOR_INDEXES (ambient, diffuse, specular)
    in
    let face = match face with
    | `front -> GL_FRONT
    | `both  -> GL_BACK
    | `back  -> GL_FRONT_AND_BACK
    in
    glMaterial ~face ~mode ;;
end


module GlList = struct

  let is_list l = glIsList l ;;

  let gen_lists ~len = glGenLists ~range:len ;;

  let delete_lists base ~len =
    glDeleteLists ~gl_list:base ~range:len ;;

  let begins l ~mode =
    glNewList ~gl_list:l ~mode:(match mode with
      | `compile -> GL_COMPILE
      | `compile_and_execute -> GL_COMPILE_AND_EXECUTE) ;;

  let ends = glEndList ;;

  let call l = glCallList ~gl_list:l ;;

  let call_lists lists =
    let gl_lists = match lists with
    | `int list_array -> list_array
    | `byte str ->
        let len = String.length str in
        Array.init (pred len) (fun i -> int_of_char str.[i])
    in
    glCallLists ~gl_lists ;;

  let list_base base = glListBase ~base ;;

  let nth base ~pos = base + pos ;;

  let create mode =
    let l = glGenLists ~range:1 in begins l ~mode; l ;;

  let delete l = delete_lists l ~len:1 ;;

  let call_lists ?base lists =
    begin match base with None -> ()
    | Some base -> list_base base
    end;
    call_lists lists ;;
end


module GlMisc = struct

  let hint hint_target hint_mode =
    let target = match hint_target with
    | `fog                    -> GL_FOG_HINT
    | `line_smooth            -> GL_LINE_SMOOTH_HINT
    | `perspective_correction -> GL_PERSPECTIVE_CORRECTION_HINT
    | `point_smooth           -> GL_POINT_SMOOTH_HINT
    | `polygon_smooth         -> GL_POLYGON_SMOOTH_HINT
    in
    let mode = match hint_mode with
    | `fastest   -> GL_FASTEST
    | `nicest    -> GL_NICEST
    | `dont_care -> GL_DONT_CARE
    in
    glHint ~target ~mode ;;

  let push_attrib attrib =
    let attrib = List.map (function
    | `accum_buffer    -> Attrib.GL_ACCUM_BUFFER_BIT
    | `color_buffer    -> Attrib.GL_COLOR_BUFFER_BIT
    | `current         -> Attrib.GL_CURRENT_BIT
    | `depth_buffer    -> Attrib.GL_DEPTH_BUFFER_BIT
    | `enable          -> Attrib.GL_ENABLE_BIT
    | `eval            -> Attrib.GL_EVAL_BIT
    | `fog             -> Attrib.GL_FOG_BIT
    | `hint            -> Attrib.GL_HINT_BIT
    | `lighting        -> Attrib.GL_LIGHTING_BIT
    | `line            -> Attrib.GL_LINE_BIT
    | `list            -> Attrib.GL_LIST_BIT
 (* | `multisample     -> Attrib.GL_MULTISAMPLE_BIT *)
    | `pixel_mode      -> Attrib.GL_PIXEL_MODE_BIT
    | `point           -> Attrib.GL_POINT_BIT
    | `polygon         -> Attrib.GL_POLYGON_BIT
    | `polygon_stipple -> Attrib.GL_POLYGON_STIPPLE_BIT
    | `scissor         -> Attrib.GL_SCISSOR_BIT
    | `stencil_buffer  -> Attrib.GL_STENCIL_BUFFER_BIT
    | `texture         -> Attrib.GL_TEXTURE_BIT
    | `transform       -> Attrib.GL_TRANSFORM_BIT
    | `viewport        -> Attrib.GL_VIEWPORT_BIT) attrib
    in
    glPushAttrib attrib ;;

  let pop_attrib = glPopAttrib ;;
end


module GlMap = struct
  let eval_coord1 u = glEvalCoord1 ~u ;;
  let eval_coord2 u v = glEvalCoord2 ~u ~v ;;

  let grid1 ~n:un ~range:(u1, u2) = glMapGrid1 ~un ~u1 ~u2 ;;
  let grid2 ~n1:un ~range1:(u1, u2)
            ~n2:vn ~range2:(v1, v2) =
    glMapGrid2 ~un ~u1 ~u2 ~vn ~v1 ~v2 ;;

  let eval_mesh1 ~mode ~range:(i1,i2) =
    let mode = match mode with
    | `point -> EvalMesh1.GL_POINT
    | `line  -> EvalMesh1.GL_LINE
    in
    glEvalMesh1 ~mode ~i1 ~i2 ;;

  let eval_mesh2 ~mode ~range1:(i1,i2) ~range2:(j1,j2) =
    let mode = match mode with
    | `point -> EvalMesh2.GL_POINT
    | `line  -> EvalMesh2.GL_LINE
    | `fill  -> EvalMesh2.GL_FILL
    in
    glEvalMesh2 ~mode ~i1 ~i2 ~j1 ~j2 ;;
end


open Glu ;;

module GluMat = struct
  let look_at ~eye:(eyeX, eyeY, eyeZ)
        ~center:(centerX, centerY, centerZ)
        ~up:(upX, upY, upZ) =
    gluLookAt ~eyeX ~eyeY ~eyeZ
        ~centerX ~centerY ~centerZ
        ~upX ~upY ~upZ ;;

  let ortho2d = gluOrtho2D ;;
  let perspective ~fovy ~aspect ~z:(zNear,zFar) = gluPerspective ~fovy ~aspect ~zNear ~zFar ;;
end


module GluQuadric = struct
  let create = gluNewQuadric ;;

  let cylinder ~base ~top ~height ~slices ~stacks ?(quad = create ()) () =
    gluCylinder ~quad ~base ~top ~height ~slices ~stacks ;;

  let disk ~inner ~outer ~slices ~loops ?(quad = create ()) () =
    gluDisk ~quad ~inner ~outer ~slices ~loops ;;

  let partial_disk ~inner ~outer ~slices ~loops ~start ~sweep ?(quad = create ()) () =
    gluPartialDisk ~quad ~inner ~outer ~slices ~loops ~start ~sweep ;;

  let sphere ~radius ~slices ~stacks ?(quad = create ()) () =
    gluSphere ~quad ~radius ~slices ~stacks ;;

  let texture quad b = gluQuadricTexture quad b ;;

  let draw_style quad d =
    let draw_style = match d with
    | `fill       -> GLU_FILL
    | `line       -> GLU_LINE
    | `silhouette -> GLU_SILHOUETTE
    | `point      -> GLU_POINT
    in
    gluQuadricDrawStyle ~quad ~draw_style ;;
 
  let orientation quad o =
    let orientation = match o with
    | `inside  -> GLU_OUTSIDE
    | `outside -> GLU_INSIDE
    in
    gluQuadricOrientation ~quad ~orientation ;;

  let normals quad n =
    let normal = match n with
    | `none   -> GLU_NONE
    | `flat   -> GLU_FLAT
    | `smooth -> GLU_SMOOTH
    in
    gluQuadricNormals ~quad ~normal ;;

end


open Glut ;;

external identity: 'a -> 'b = "%identity"

module Glut = struct
  type button_t =
      | LEFT_BUTTON
      | MIDDLE_BUTTON
      | RIGHT_BUTTON
      | OTHER_BUTTON of int

  type mouse_button_state_t =
      | DOWN
      | UP

  type special_key_t =
      | KEY_F1
      | KEY_F2
      | KEY_F3
      | KEY_F4
      | KEY_F5
      | KEY_F6
      | KEY_F7
      | KEY_F8
      | KEY_F9
      | KEY_F10
      | KEY_F11
      | KEY_F12
       (* directional keys *)
      | KEY_LEFT
      | KEY_UP
      | KEY_RIGHT
      | KEY_DOWN
      | KEY_PAGE_UP
      | KEY_PAGE_DOWN
      | KEY_HOME
      | KEY_END
      | KEY_INSERT

  let mainLoop = glutMainLoop ;;
  let init = glutInit ;;
  let createWindow = glutCreateWindow ;;
  let initWindowSize ~w ~h = glutInitWindowSize ~width:w ~height:h ;;

  let initDisplayMode
    ?(double_buffer=false)
    ?(index=false)
    ?(accum=false)
    ?(alpha=false)
    ?(depth=false)
    ?(stencil=false)
    ?(multisample=false)
    ?(stereo=false)
    ?(luminance=false)
    () =
    let mode = [] in
    let mode = if double_buffer then GLUT_DOUBLE      :: mode else mode in
    let mode = if index         then GLUT_INDEX       :: mode else mode in
    let mode = if accum         then GLUT_ACCUM       :: mode else mode in
    let mode = if alpha         then GLUT_ALPHA       :: mode else mode in
    let mode = if depth         then GLUT_DEPTH       :: mode else mode in
    let mode = if stencil       then GLUT_STENCIL     :: mode else mode in
    let mode = if multisample   then GLUT_MULTISAMPLE :: mode else mode in
    let mode = if stereo        then GLUT_STEREO      :: mode else mode in
    let mode = if luminance     then GLUT_LUMINANCE   :: mode else mode in
    (* GLUT_RGBA
       GLUT_RGB
       GLUT_SINGLE *)
    glutInitDisplayMode ~mode ;;

  let swapBuffers = glutSwapBuffers ;;
  let postRedisplay = glutPostRedisplay ;;
  let fullScreen = glutFullScreen ;;
  let initWindowPosition = glutInitWindowPosition ;;
  let initWindowSize ~w ~h = glutInitWindowSize ~width:w ~height:h ;;
  let setWindowTitle ~title = glutSetWindowTitle ~name:title ;;

  let displayFunc ~cb = glutDisplayFunc ~display:cb ;;

  let idleFunc ~cb =
    match cb with
    | Some idle -> glutIdleFunc ~idle
    | None -> glutRemoveIdleFunc() ;;

  let keyboardFunc ~cb =
    let keyboard ~key:c ~x ~y = cb ~key:(int_of_char c) ~x ~y in
    glutKeyboardFunc ~keyboard ;;

  let keyboardUpFunc ~cb =
    let keyboard_up ~key:c ~x ~y = cb ~key:(int_of_char c) ~x ~y in
    glutKeyboardUpFunc ~keyboard_up ;;

  let reshapeFunc ~cb =
    let reshape ~width ~height = cb ~w:width ~h:height in
    glutReshapeFunc ~reshape ;;

  let specialFunc ~cb =
    let special ~key ~x ~y =
      let key = match key with
      | GLUT_KEY_F1  -> KEY_F1
      | GLUT_KEY_F2  -> KEY_F2
      | GLUT_KEY_F3  -> KEY_F3
      | GLUT_KEY_F4  -> KEY_F4
      | GLUT_KEY_F5  -> KEY_F5
      | GLUT_KEY_F6  -> KEY_F6
      | GLUT_KEY_F7  -> KEY_F7
      | GLUT_KEY_F8  -> KEY_F8
      | GLUT_KEY_F9  -> KEY_F9
      | GLUT_KEY_F10 -> KEY_F10
      | GLUT_KEY_F11 -> KEY_F11
      | GLUT_KEY_F12 -> KEY_F12
      | GLUT_KEY_LEFT      -> KEY_LEFT
      | GLUT_KEY_UP        -> KEY_UP
      | GLUT_KEY_RIGHT     -> KEY_RIGHT
      | GLUT_KEY_DOWN      -> KEY_DOWN
      | GLUT_KEY_PAGE_UP   -> KEY_PAGE_UP
      | GLUT_KEY_PAGE_DOWN -> KEY_PAGE_DOWN
      | GLUT_KEY_HOME      -> KEY_HOME
      | GLUT_KEY_END       -> KEY_END
      | GLUT_KEY_INSERT    -> KEY_INSERT
      in
      cb ~key ~x ~y
    in
    glutSpecialFunc ~special ;;

  let specialUpFunc ~cb =
    let special_up ~key ~x ~y =
      let key = match key with
      | GLUT_KEY_F1  -> KEY_F1
      | GLUT_KEY_F2  -> KEY_F2
      | GLUT_KEY_F3  -> KEY_F3
      | GLUT_KEY_F4  -> KEY_F4
      | GLUT_KEY_F5  -> KEY_F5
      | GLUT_KEY_F6  -> KEY_F6
      | GLUT_KEY_F7  -> KEY_F7
      | GLUT_KEY_F8  -> KEY_F8
      | GLUT_KEY_F9  -> KEY_F9
      | GLUT_KEY_F10 -> KEY_F10
      | GLUT_KEY_F11 -> KEY_F11
      | GLUT_KEY_F12 -> KEY_F12
      | GLUT_KEY_LEFT      -> KEY_LEFT
      | GLUT_KEY_UP        -> KEY_UP
      | GLUT_KEY_RIGHT     -> KEY_RIGHT
      | GLUT_KEY_DOWN      -> KEY_DOWN
      | GLUT_KEY_PAGE_UP   -> KEY_PAGE_UP
      | GLUT_KEY_PAGE_DOWN -> KEY_PAGE_DOWN
      | GLUT_KEY_HOME      -> KEY_HOME
      | GLUT_KEY_END       -> KEY_END
      | GLUT_KEY_INSERT    -> KEY_INSERT
      in
      cb ~key ~x ~y
    in
    glutSpecialUpFunc ~special_up ;;

  let mouseFunc ~cb =
    let mouse ~button ~state ~x ~y =
      let button = match button with
      | GLUT_LEFT_BUTTON   -> LEFT_BUTTON 
      | GLUT_MIDDLE_BUTTON -> MIDDLE_BUTTON 
      | GLUT_RIGHT_BUTTON  -> RIGHT_BUTTON
      | GLUT_WHEEL_UP      -> OTHER_BUTTON 3
      | GLUT_WHEEL_DOWN    -> OTHER_BUTTON 3
      in
      let state = match state with
      | GLUT_DOWN -> DOWN
      | GLUT_UP   -> UP
      in
      cb ~button ~state ~x ~y
    in
    glutMouseFunc ~mouse ;;

  let timerFunc ~ms ~cb ~value = glutTimerFunc ~msecs:ms ~timer:cb ~value ;;
  let motionFunc ~cb = glutMotionFunc ~motion:cb ;;
  let passiveMotionFunc ~cb = glutPassiveMotionFunc ~passive:cb ;;

  type entry_exit_state_t =
    | LEFT
    | ENTERED

  let entryFunc ~cb =
    let entry ~state =
      cb ~state:(match state with
      | GLUT_LEFT    -> LEFT
      | GLUT_ENTERED -> ENTERED)
    in
    glutEntryFunc ~entry ;;

  type visibility_state_t =
    | NOT_VISIBLE
    | VISIBLE

  let visibilityFunc ~cb =
    let visibility ~state =
      cb ~state:(match state with
      | GLUT_NOT_VISIBLE -> NOT_VISIBLE
      | GLUT_VISIBLE     -> VISIBLE)
    in
    glutVisibilityFunc ~visibility ;;

end


(* vim: sw=2 sts=2 ts=2 et fdm=marker
 *)
