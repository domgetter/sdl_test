#version 130

uniform float time;
out vec3 color;

void main() {
  /* color = vec3(1.0, 0.0, sin(time / 10.0) / 2.0); */
  if (gl_FragCoord.x < 300.0) {
    color = vec3(0.5, cos(time), 0.7);
  } else {
    color = vec3(1.0, 0.0, (sin(time/10.0) + 1.0) / 2.0);
  }
}
