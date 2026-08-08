// Cursor smear for Ghostty.
// Post-process shader: leaves a brief, fading trail (capsule) from the previous
// cursor position to the current one when the cursor moves. When idle it is a
// no-op (alpha 0), so it never alters the normal terminal image.

float sdBox(in vec2 p, in vec2 b) {
    vec2 d = abs(p) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// Normalize pixel coords to an aspect-correct space (y in [-1,1]).
vec2 nrm(vec2 v, float isPos) {
    return (v * 2.0 - iResolution.xy * isPos) / iResolution.y;
}

// Antialiased coverage for a signed distance.
float aa(float dist) {
    return 1.0 - smoothstep(0.0, nrm(vec2(2.0), 0.0).x, dist);
}

const float DURATION = 0.15; // seconds

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Start from the already-rendered terminal (cursor included).
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);

    vec2 vu      = nrm(fragCoord, 1.0);
    vec2 curSize = nrm(iCurrentCursor.zw, 0.0);
    vec2 curC    = nrm(vec2(iCurrentCursor.x  + iCurrentCursor.z  * 0.5,
                            iCurrentCursor.y  - iCurrentCursor.w  * 0.5), 1.0);
    vec2 prevC   = nrm(vec2(iPreviousCursor.x + iPreviousCursor.z * 0.5,
                            iPreviousCursor.y - iPreviousCursor.w * 0.5), 1.0);

    // Animation progress (eased). At rest progress == 1 -> alpha 0 -> no-op.
    float p = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    float e = 1.0 - pow(1.0 - p, 3.0);           // easeOutCubic
    vec2 trail = mix(prevC, curC, e);            // lagging position

    // Capsule (rounded segment) between the lagging point and the cursor.
    vec2 d    = curC - trail;
    float L   = max(length(d), 1e-4);
    vec2 dir  = d / L;
    float proj = clamp(dot(vu - trail, dir), 0.0, L);
    vec2 closest = trail + dir * proj;
    float dist = length(vu - closest) - curSize.y * 0.5;

    float alpha = aa(dist) * (1.0 - e);          // fades as the move completes
    fragColor = mix(fragColor, iCurrentCursorColor, alpha);
}
