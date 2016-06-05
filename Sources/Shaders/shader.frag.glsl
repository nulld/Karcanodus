precision mediump float;

void main() {
    float cosTheta = clamp(dot(2.0, 1.0), 0.0, 1.0);
    gl_FragColor = vec4(1.0, cosTheta, 0.0, 1.0);
}