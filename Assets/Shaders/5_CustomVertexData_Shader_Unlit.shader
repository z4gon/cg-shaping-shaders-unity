Shader "Unlit/5_CustomVertexData_Shader_Unlit"
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
                // from (0.5, -0.5, 0.0) to (1, -1 , 0)
                fixed3 position = i.position * 2;

                // saturate clamps values to (0, 1)
                fixed3 color = saturate(position);

                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
