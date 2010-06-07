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
