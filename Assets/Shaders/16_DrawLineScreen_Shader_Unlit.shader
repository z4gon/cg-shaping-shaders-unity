Shader "Unlit/16_DrawLineScreen_Shader_Unlit"
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

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.screenPos.xy / i.screenPos.w;

                float isOnLine = onLine(uv.x, uv.y, _Width, _Smoothness);

                return fixed4(1,1,1,1) * isOnLine;
            }
            ENDCG
        }
    }
}
