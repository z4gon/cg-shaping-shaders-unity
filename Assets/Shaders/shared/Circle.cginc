float checkInCircle(float2 position, float2 center, float radius, bool soften = false)
{
    // returns 1 if the point is inside the circle defined by center and radius

    fixed r = length(position - center);

    float softenThreshold = soften ? radius * 0.2 : 0.0;

    fixed outCircle = smoothstep(radius - softenThreshold, radius + softenThreshold, r);
    fixed inCircle = 1 - outCircle;

    return inCircle;
}
