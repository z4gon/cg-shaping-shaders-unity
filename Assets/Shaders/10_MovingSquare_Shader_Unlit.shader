Shader "Unlit/10_MovingSquare_Shader_Unlit"
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

            fixed4 frag (v2f i) : SV_Target
            {
                float movementRadius = 0.3;

                // square measurements
                float2 center = float2(cos(_Time.w),sin(_Time.w)) * movementRadius;
                float2 size = 0.2;

                float2 position = i.position.xy * 2.0;

                fixed inRect = rect(position, center, size);

                return fixed4(1,1,0,1) * inRect;
            }
            ENDCG
        }
    }
}
