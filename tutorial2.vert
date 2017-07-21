#version 150

attribute vec3 in_Position;
attribute vec4 in_Color;

out vec4 ex_Color;

void main(void) {
  gl_Position = vec4(in_Position.xyz, 1.0)

  ex_Color = in_Color;
}
