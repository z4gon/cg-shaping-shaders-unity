float polygon(float2 position, float2 center, float radius, int sides, float rotate)
{
    // returns 1 if the point is inside the polygon
    float2 testPoint = position - center;

    // angle and radius of the current test pixel
    float theta = atan2(testPoint.x, testPoint.y) + rotate;
    float radiansPerSide = UNITY_TWO_PI/float(sides);

    // function that checks if the pixel is inside the polygon
    float d = cos(floor(0.5 + theta/radiansPerSide) * radiansPerSide - theta) * length(testPoint);

    return 1.0 - step(radius, d);
}
