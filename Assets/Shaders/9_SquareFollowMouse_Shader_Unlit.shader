Shader "Unlit/9_SquareFollowMouse_Shader_Unlit"
{
    Properties
    {
        _MousePosition("Mouse Position", Vector) = (0,0,0,0)
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

            float4 _MousePosition;

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

            float checkInRect(float2 position, float2 center, float2 size)
            {
                // returns 1 when the position is inside the rect defined by center and size
                float2 p = position - center;

                float2 halfSize = size * 0.5;

                // 0 if less than -halfSize, 1 if between -halfSize and halfSize, 0 if over halfSize
                float2 test = step(-halfSize, p) - step(halfSize, p);

                return test.x * test.y;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 position = i.uv;
                fixed inSquare = checkInRect(position, _MousePosition.xy, float2(0.1, 0.1));

                return fixed4(1,1,0,1) * inSquare;
            }
            ENDCG
        }
    }
}
