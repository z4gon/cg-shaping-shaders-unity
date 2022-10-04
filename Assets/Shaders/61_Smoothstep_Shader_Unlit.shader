Shader "Unlit/61_Smoothstep_Shader_Unlit"
{
    Properties
    {
        _EdgeStart("Smoothstep Edge Start", Range(-1.0, 1.0)) = 0
        _EdgeEnd("Smoothstep Edge End", Range(-1.0, 1.0)) = 0.3
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

            float _EdgeStart;
            float _EdgeEnd;

            fixed4 frag (v2f i) : SV_Target
            {
                // transforms values like this: (0.5, -0.5, 0.0) to (1, -1 , 0)
                fixed3 color = i.position * 2;

                color.r = smoothstep(_EdgeStart, _EdgeEnd, color.r);
                color.g = smoothstep(_EdgeStart, _EdgeEnd, color.g);

                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
