Shader "Unlit/82_Rects_Shader_Unlit"
{
    Properties
    {
        _Rect1("Rect 1", Vector) = (-0.2, -0.2, 0.2, 0.2)
        _Rect2("Rect 2", Vector) = (0.2, 0.2, 0.2, 0.2)
        _Color1("Color 1", Color) = (1,0,0,1)
        _Color2("Color 2", Color) = (0,0,1,1)
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

            float4 _Rect1;
            float4 _Rect2;
            fixed4 _Color1;
            fixed4 _Color2;

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
                float2 p = position - center;

                float2 halfSize = size * 0.5;

                float horizontal = step(-halfSize.x, p.x) - step(halfSize.x, p.x);
                float vertical = step(-halfSize.y, p.y) - step(halfSize.y, p.y);

                return horizontal * vertical;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 position = i.position.xy;
                fixed inRect1 = checkInRect(position, _Rect1.xy, _Rect1.zw);
                fixed inRect2 = checkInRect(position, _Rect2.xy, _Rect2.zw);

                return _Color1 * inRect1 + _Color2 * inRect2;
            }
            ENDCG
        }
    }
}
