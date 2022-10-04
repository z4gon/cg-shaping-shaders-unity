float checkInCircle(float2 position, float2 center, float radius)
{
    // returns 1 if the point is inside the circle defined by center and radius

    fixed r = length(position - center);
    fixed outCircle = step(radius, r);
    fixed inCircle = 1 - outCircle;

    return inCircle;
}
