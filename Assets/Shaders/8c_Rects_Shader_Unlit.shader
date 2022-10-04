Shader "Unlit/8c_Rects_Shader_Unlit"
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
            #include "./shared/Rect.cginc"
            #include "./shared/SimpleV2F.cginc"

            float4 _Rect1;
            float4 _Rect2;
            fixed4 _Color1;
            fixed4 _Color2;

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
