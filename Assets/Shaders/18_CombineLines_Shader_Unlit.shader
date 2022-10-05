Shader "Unlit/18_CombineLines_Shader_Unlit"
{
    Properties
    {
        _Width("Line Width", Float) = 0.05
        _Smoothness("Smoothness", Float) = 0.02
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
            float _Smoothness;

            float getTransformedSin(float x){
                return ((sin(x) + 1.0) / 2.0) - 0.5;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 position = i.uv;

                fixed4 lineColor = fixed4(1,1,1,1);

                // draw a crosshair
                float4 color = lineColor * onLine(position.x, 0.5, _Width, 0);
                color += lineColor * onLine(position.y, 0.5, _Width, 0);

                float2 center = 0.5;
                color += lineColor * checkInCircle(position, center, 0.3, _Width);
                color += lineColor * checkInCircle(position, center, 0.2, _Width);
                color += lineColor * checkInCircle(position, center, 0.1, _Width);

                return color;
            }
            ENDCG
        }
    }
}
