Shader "Unlit/6_Step_Shader_Unlit"
{
    Properties
    {
        _StepEdge("Step Edge", Range(-1.0, 1.0)) = 0
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

            float _StepEdge;

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
                // transforms values like this: (0.5, -0.5, 0.0) to (1, -1 , 0)
                fixed3 color = i.position * 2;

                color.r = step(_StepEdge, color.r);
                color.g = step(_StepEdge, color.g);

                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
