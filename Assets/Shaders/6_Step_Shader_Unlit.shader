Shader "Unlit/6_Step_Shader_Unlit"
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

            float _EdgeStart;
            float _EdgeEnd;

            struct v2f
            {
                // Cg Semantics
                //      Binds Shader input/output to rendering hardware
                //      - SV_POSITION means system value position in DX10, corresponds to vertex position
                //      - TEXCOORDn means custom data

                float4 vertex: SV_POSITION; // From Object-Space to Clip-Space
                float4 position: TEXCOORD1;
                float4 uv: TEXCOORD0;
            };

            v2f vert (appdata_base v) {
                v2f output;

                output.vertex = UnityObjectToClipPos(v.vertex);
                output.position = v.vertex;
                output.uv = v.texcoord;

                return output;
            }

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
