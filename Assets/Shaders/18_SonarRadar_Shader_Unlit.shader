Shader "Unlit/18_SonarRadar_Shader_Unlit"
{
    Properties
    {
        _Width("Line Width", Float) = 0.05
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "./shared/SimpleV2F.cginc"
            #include "./shared/Line.cginc"
            #include "./shared/Circle.cginc"

            float _Width;


            float sweepGradientTrail(float2 testPoint, float theta, float radius)
            {
                if(length(testPoint) > radius){
                    return 0;
                }

                const float sweepGradientTrailAngle = UNITY_PI * 0.5;

                float angleOfTestPoint = atan2(testPoint.y, testPoint.x);
                float angleToSweepLine = angleOfTestPoint + theta; // angles are counter clock-wise
                angleToSweepLine = fmod(angleToSweepLine + UNITY_TWO_PI , UNITY_TWO_PI); // modulo to 2pi

                // clamp angle so that it is not bigger than the gradientAngle
                float gradientAngleUsed = clamp(
                    sweepGradientTrailAngle - angleToSweepLine,
                    0.0,
                    sweepGradientTrailAngle
                );

                return (gradientAngleUsed / sweepGradientTrailAngle) * 0.5;
            }

            float sweep(float2 position, float2 center, float radius, float lineWidth, float edgeThickness)
            {
                // translate position to the coordinates system on the center
                float2 testPoint = position - center;

                // create an angle in radians from the time
                float theta = _Time.w;

                // point that defines the line of the sweep, from the center
                float2 guidePoint = float2(cos(theta), -sin(theta)) * radius;

                // length of the line when projecting the test point onto the guide point's line
                float projectedMagnitude = dot(testPoint, guidePoint) / dot(guidePoint, guidePoint);

                // clamp to maximum 1
                projectedMagnitude = clamp(projectedMagnitude, 0.0, 1.0);

                // get the projected point in the guide point's line
                float2 projectedPoint = guidePoint * projectedMagnitude;

                float distanceToSweepLine = length(testPoint - projectedPoint);

                // calculate gradient trail
                float gradientTrail = sweepGradientTrail(testPoint, theta, radius);

                return gradientTrail + 1.0 - smoothstep(lineWidth, lineWidth - edgeThickness, distanceToSweepLine);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 position = i.uv;

                fixed4 lineColor = fixed4(1,1,1,1);

                // draw a crosshair
                float4 color = lineColor * onLine(position.x, 0.5, _Width, 0);
                color += lineColor * onLine(position.y, 0.5, _Width, 0);

                float2 center = 0.5;
                color += lineColor * circle(position, center, 0.3, _Width);
                color += lineColor * circle(position, center, 0.2, _Width);
                color += lineColor * circle(position, center, 0.1, _Width);
                color += fixed4(0,1,0,1) * sweep(position, center, 0.3, _Width, 0);

                return color;
            }
            ENDCG
        }
    }
}
