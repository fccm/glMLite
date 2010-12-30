(* Simple Demo for GLSL *)
(* This demo comes from this tutorial: *)
(* http://www.lighthouse3d.com/opengl/glsl/ *)

open GL
open Glu
open Glut


let changeSize ~width:w ~height:h =
  (* Prevent a divide by zero, when window is too short
     (you cant make a window of zero width). *)
  let h =
    if h = 0
    then 1
    else h
  in

  let ratio = 1.0 *. float w /. float h in

  (* Reset the coordinate system before modifying *)
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  
  (* Set the viewport to be the entire window *)
  glViewport 0 0 w h;

  (* Set the correct perspective. *)
  gluPerspective 45.0 ratio 1.0 1000.0;
  glMatrixMode GL_MODELVIEW;
;;


let renderScene() =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  glLoadIdentity();
  gluLookAt 0.0 0.0 5.0
            0.0 0.0 (-1.0)
            0.0 1.0 0.0;

  let lpos = (1.0, 0.5, 1.0, 0.0) in
  glLight (GL_LIGHT 0) (Light.GL_POSITION lpos);
  glutSolidTeapot 1.0;

  glutSwapBuffers();
;;


let processNormalKeys ~key ~x ~y =
  if key = '\027' then exit 0;
;;


let toon_frag = "
// simple toon fragment shader
varying vec3 normal, lightDir;

void main()
{
    float intensity;
    vec3 n;
    vec4 color;

    n = normalize(normal);
    intensity = max(dot(lightDir,n),0.0);

    if (intensity > 0.98)
        color = vec4(0.8,0.8,0.8,1.0);
    else if (intensity > 0.5)
        color = vec4(0.4,0.4,0.8,1.0);
    else if (intensity > 0.25)
        color = vec4(0.2,0.2,0.4,1.0);
    else
        color = vec4(0.1,0.1,0.1,1.0);

    gl_FragColor = color;
}
"

let toon_vert = "
// simple toon vertex shader
varying vec3 normal, lightDir;

void main()
{
    lightDir = normalize(vec3(gl_LightSource[0].position));
    normal = normalize(gl_NormalMatrix * gl_Normal);

    gl_Position = ftransform();
}
"

let toon2_frag = "
vec4 toonify(in float intensity)
{
    vec4 color;

    if (intensity > 0.98)
        color = vec4(0.8,0.8,0.8,1.0);
    else if (intensity > 0.5)
        color = vec4(0.4,0.4,0.8,1.0);
    else if (intensity > 0.25)
        color = vec4(0.2,0.2,0.4,1.0);
    else
        color = vec4(0.1,0.1,0.1,1.0);

    return(color);
}
"

let setShaders() =
  let v = glCreateShader GL_VERTEX_SHADER
  and f = glCreateShader GL_FRAGMENT_SHADER
  and f2 = glCreateShader GL_FRAGMENT_SHADER in

  glShaderSource v toon_vert;
  glShaderSource f toon_frag;
  glShaderSource f2 toon2_frag;

  glCompileShader v;
  glCompileShader f;
  glCompileShader f2;

  let p = glCreateProgram() in
  glAttachShader p f;
  glAttachShader p f2;
  glAttachShader p v;

  glLinkProgram p;
  glUseProgram p;
;;


(* main *)
let () =
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_DEPTH; GLUT_DOUBLE; GLUT_RGBA];
  glutInitWindowPosition 100 100;
  glutInitWindowSize 320 320;
  ignore(glutCreateWindow "MM 2004-05");

  glutDisplayFunc renderScene;
  glutIdleFunc renderScene;
  glutReshapeFunc changeSize;
  glutKeyboardFunc processNormalKeys;

  glEnable GL_DEPTH_TEST;
  glClearColor 1.0 1.0 1.0 1.0;

  setShaders();

  glutMainLoop();
;;

