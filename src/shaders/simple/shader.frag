#version 130

/* in vec2 vertColor; */
/* uniform float time; */
out vec3 color;
in vec4 fragColor;

void main() {
  /* color = vec3(0.8, 0.2, 0.1); */
  color = fragColor.rgb;
  /* if (gl_FragCoord.x < 300.0) { */
  /*   color = vec3(0.5, cos(time/100.0)/7.0, 0.7); */
  /* } else { */
  /*   color = vec3(1.0, (cos(gl_FragCoord.x/100.0) + 1.0) / 2.0, (sin(time/100.0) + 1.0) / 4.0); */
  /* } */
}
