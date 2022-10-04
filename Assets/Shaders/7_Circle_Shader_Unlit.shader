Shader "Unlit/7_Circle_Shader_Unlit"
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

            v2f vert (appdata_base v)
            {
                v2f output;

                output.vertex = UnityObjectToClipPos(v.vertex);
                output.position = v.vertex;
                output.uv = v.texcoord;

                return output;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed r = length(i.position.xy);
                fixed outCircle = step(_Radius, r);
                fixed inCircle = 1 - outCircle;

                return fixed4(1,1,1,1) * inCircle;
            }
            ENDCG
        }
    }
}