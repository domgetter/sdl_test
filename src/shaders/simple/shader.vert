// version 130 targets OpenGL 3.0
#version 130

/* uniform float real_time; */
in vec3 vertexPosition;
out vec4 fragColor;
uniform mat4 transform;

void main() {
  /* if(sin(real_time/90.0) > 0.0f) { */
  /*   gl_Position.x = vertexPosition.x / 2.0 + 0.1 + 0.2; */
  /* } else { */
  /*   gl_Position.x = vertexPosition.x / 2.0 + 0.1; */
  /* } */
  /* gl_Position.x = vertexPosition.x / 2.0 + sin(real_time)/5.0; */
    
  /* gl_Position.y = vertexPosition.y / 2.0 + 0.1; */
  gl_Position = transform * vec4(vertexPosition, 1.0);
  /* if(gl_Position.x < 0.3) { */
  if(gl_VertexID == 0) {
    fragColor = vec4(1.0, 0.0, 0.0, 1.0);
  } else if(gl_VertexID == 1) {
    fragColor = vec4(1.0, 0.0, 0.0, 1.0);
  } else if(gl_VertexID == 4) {
    fragColor = vec4(1.0, 0.0, 0.0, 1.0);
  } else if(gl_VertexID == 5) {
    fragColor = vec4(0.0, 1.0, 0.5, 1.0);
  } else if(gl_VertexID == 7) {
    fragColor = vec4(0.5, 1.0, 1.0, 1.0);
  } else {
    fragColor = vec4(0.0, 0.0, 1.0, 1.0);
  }

}
