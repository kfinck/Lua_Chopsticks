vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263, 0.416, 0.557);
    return a + b*cos(6.28318*(c*t+d));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord *2.0 - iResolution.xy)/iResolution.y;
    vec2 uv0=uv;
    vec3 finalcol=vec3(0.);
    for(float i=0.;i<4.;i++){

        uv=fract(uv*2.5)-0.5;
        float d = length(uv)*exp(-length(uv0));

        vec3 col = palette(length(uv0)+iTime*5.+i*.100);
    

        d=sin(d*4.+iTime*1.2)/2.;
        d=abs(d);
        d=0.02/d;
        d=pow(d,5.);
        col*=d;
        finalcol+=col;
    }

    fragColor = vec4(finalcol, 1.0);
}