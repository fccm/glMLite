(*
  Copyright (C) 2010 Florent Monnier

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the "Software"),
  to deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  The Software is provided "as is", without warranty of any kind, express or
  implied, including but not limited to the warranties of merchantability,
  fitness for a particular purpose and noninfringement. In no event shall
  the authors or copyright holders be liable for any claim, damages or other
  liability, whether in an action of contract, tort or otherwise, arising
  from, out of or in connection with the software or the use or other dealings
  in the Software.
*)
(** glsl shader programs *)

(* interpolate RGB colors of the vertices, no lighting *)
let interpolate_rgb = "
// vertex shader
#version 130
in vec3 VertexColor;
in vec3 VertexPosition;
uniform mat4 ModelViewProjectionMatrix;
invariant gl_Position;
smooth out vec3 InterpolatedColor;

void main () {
    InterpolatedColor = VertexColor;
    gl_Position = ModelViewProjectionMatrix * vec4 (VertexPosition, 1.0);
}",
"// fragment shader
#version 130
precision highp float;
smooth in vec3 InterpolatedColor;
out vec4 Color;
void main() {
    Color = vec4 (InterpolatedColor, 1.0);
}"

(* interpolate UV texture coordinates, no color, do replace *)
let interpolate_uv = "
// vertex shader
#version 130
in vec2 VertexUV;
in vec3 VertexPosition;
uniform mat4 ModelViewProjectionMatrix;
invariant gl_Position;
smooth out vec2 InterpolatedUV;
void main () {
    InterpolatedUV = VertexUV;
    gl_Position = ModelViewProjectionMatrix * vec4 (VertexPosition, 1.0);
}",
"// fragment shader
#version 130
precision highp float;
uniform sampler2D texture0;
smooth in vec2 InterpolatedUV;
out vec4 Color;
void main() {
    Color = texture(texture0, InterpolatedUV);
}"

(* interpolate RGB and UV *)
let interpolate_uv_rgb = "
// vertex shader
#version 130
in vec2 VertexUV;
in vec3 VertexColor;
in vec3 VertexPosition;
uniform mat4 ModelViewProjectionMatrix;
invariant gl_Position;
smooth out vec3 InterpolatedColor;
smooth out vec2 InterpolatedUV;

void main () {
    InterpolatedUV = VertexUV;
    InterpolatedColor = VertexColor;
    gl_Position = ModelViewProjectionMatrix * vec4 (VertexPosition, 1.0);
}",
"// fragment shader
#version 130
precision highp float;
uniform sampler2D texture0;
uniform int TexEnv;
smooth in vec3 InterpolatedColor;
smooth in vec2 InterpolatedUV;
out vec4 Color;
void main() {
    vec4 vert_color = vec4(InterpolatedColor, 1.0);
    vec4 tex_color = texture(texture0, InterpolatedUV);
    if (TexEnv == 0) {  // MODULATE
        Color = vert_color * tex_color;
    } else
    if (TexEnv == 1) {  // DECAL
        vec3 col = mix(vert_color.rgb, tex_color.rgb, tex_color.a);
        Color = vec4(col, vert_color.a);
    } else
    if (TexEnv == 2) {  // ADD
        vert_color.rgb += tex_color.rgb;
        vert_color.a *= tex_color.a;
        Color = clamp(vert_color, 0.0, 1.0);
    } else
    if (TexEnv == 3) {  // ADD_SIGNED
        vert_color.rgb += tex_color.rgb;
        vert_color.rgb -= vec3(0.5, 0.5, 0.5);
        vert_color.a *= tex_color.a;
        Color = clamp(vert_color, 0.0, 1.0);
    } else
    if (TexEnv == 4) {  // SUBTRACT
        vert_color.rgb -= tex_color.rgb;
        vert_color.a *= tex_color.a;
        Color = clamp(vert_color, 0.0, 1.0);
    } else
    //Color = tex_color;  // REPLACE
    Color = vec4(1.0, 0.2, 0.0, 1.0);
}"

let plain_color_vertex_shader = "
// vertex shader
#version 130
in vec3 VertexPosition;
uniform mat4 ModelViewProjectionMatrix;
invariant gl_Position;
void main () {
    gl_Position = ModelViewProjectionMatrix * vec4 (VertexPosition, 1.0);
}"

let plain_color3 (r,g,b) = plain_color_vertex_shader,
Printf.sprintf
"// fragment shader
#version 130
precision highp float;
out vec4 Color;
void main() {
    Color = vec4 (%f,%f,%f,1.0);
}" r g b

let plain_color4 (r,g,b,a) = plain_color_vertex_shader,
Printf.sprintf
"// fragment shader
#version 130
precision highp float;
out vec4 Color;
void main() {
    Color = vec4 (%f,%f,%f,%f);
}" r g b a

let plain_varying_color = plain_color_vertex_shader,
"// fragment shader
#version 130
precision highp float;
uniform vec3 PlainColor;
out vec4 Color;
void main() {
    Color = vec4 (PlainColor, 1.0);
}"

(* vim: sw=4 sts=4 ts=4 filetype=glsl
 *)
