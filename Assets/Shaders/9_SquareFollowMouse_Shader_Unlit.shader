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
            #include "./shared/Rect.cginc"
            #include "./shared/SimpleV2F.cginc"

            float4 _MousePosition;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 position = i.uv;
                fixed inRect = rect(position, _MousePosition.xy, float2(0.1, 0.1));

                return fixed4(1,1,0,1) * inRect;
            }
            ENDCG
        }
    }
}
