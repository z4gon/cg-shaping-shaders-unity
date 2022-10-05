float onLine(float x, float y, float lineWidth, float edgeThickness)
{
    float halfLineWidth = lineWidth * 0.5;

    // returns 1 when (x,y) is in the line: x = y
    return smoothstep(
        x - halfLineWidth - edgeThickness,
        x - halfLineWidth,
        y
    ) - smoothstep(
        x + halfLineWidth,
        x + halfLineWidth + edgeThickness,
        y
    );
}
