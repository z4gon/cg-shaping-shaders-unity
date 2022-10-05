Shader "Unlit/16c_DrawSinusoidal_Shader_Unlit"
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

            float _Width;
            float _Smoothness;

            float getTransformedSin(float x){
                return ((sin(x) + 1.0) / 2.0) - 0.5;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 position = i.position.xy * 2;
                // for UVs:
                // float2 position = (i.uv - 0.5) * 2;

                // onLine checks that x = y, so, this will check that the sin() function is rendered
                float sinValue = getTransformedSin(position.x * UNITY_PI);
                float isOnLine = onLine(position.y, sinValue, _Width, _Smoothness);

                return fixed4(1,1,1,1) * isOnLine;
            }
            ENDCG
        }
    }
}
