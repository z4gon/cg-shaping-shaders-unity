Shader "Unlit/8_Square_Shader_Unlit"
{
    Properties
    {
        _CenterX("Center X", Range(-0.5, 0.5)) = 0
        _CenterY("Center Y", Range(-0.5, 0.5)) = 0
        _Size("Size", Range(0.0, 1.0)) = 0.5
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
            #include "./shared/Rect.cginc"
            #include "./shared/SimpleV2F.cginc"

            float _CenterX;
            float _CenterY;
            float _Size;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 position = i.position.xy;
                fixed inRect = checkInRect(position, float2(_CenterX, _CenterY), float2(_Size, _Size));

                return fixed4(1,1,1,1) * inRect;
            }
            ENDCG
        }
    }
}
