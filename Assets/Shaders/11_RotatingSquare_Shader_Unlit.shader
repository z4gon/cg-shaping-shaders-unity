Shader "Unlit/11_RotatingSquare_Shader_Unlit"
{
    Properties
    {
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
            #include "./shared/Matrices.cginc"

            fixed4 frag (v2f i) : SV_Target
            {
                // rotation
                float2x2 rotation = getRotationMatrix2D(_Time.w);

                // square measurements
                float2 size = 0.5;

                float2 position = i.position.xy * 2.0;
                float2 rotatedPos = mul(rotation, position);

                fixed inRect = checkInRect(rotatedPos, float2(0,0), size);

                return fixed4(1,1,0,1) * inRect;
            }
            ENDCG
        }
    }
}
