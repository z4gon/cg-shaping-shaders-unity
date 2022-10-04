float2x2 getRotationMatrix2D(float theta)
{
    float s = sin(theta);
    float c = cos(theta);

    return float2x2(c,-s,s,c);
}

float2x2 getScaleMatrix2D(float scale)
{
    return float2x2(scale,0,0,scale);
}
