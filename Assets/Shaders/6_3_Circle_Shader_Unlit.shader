Shader "Unlit/6_3_Circle_Shader_Unlit"
{
    Properties
    {
        _Radius("Radius", Range(0.0, 1.0)) = 0.3
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

            float _Radius;

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
                fixed radius = length(i.position.xy);

                if (radius <= _Radius) {
                    return fixed4(1,1,1,1);
                }

                return fixed4(0,0,0,0);
            }
            ENDCG
        }
    }
}
