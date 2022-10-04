Shader "Unlit/11_RotatingSquare_Shader_Unlit"
{
    Properties
    {
        _RotationCenter("Rotation Center", Vector) = (0,0,0,0)
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
            #include "./shared/Matrices.cginc"

            float2 _RotationCenter;

            fixed4 frag (v2f i) : SV_Target
            {
                // rotation
                float2x2 rotation = getRotationMatrix2D(_Time.w);

                // square measurements
                float2 size = 0.5;

                float2 position = i.position.xy * 2.0;

                // reposition the pixel at the center, rotate around zero, then put back in place
                float2 rotatedPos = mul(rotation, position - _RotationCenter) + _RotationCenter;

                fixed inRect = checkInRect(rotatedPos, _RotationCenter, size);

                return fixed4(1,1,0,1) * inRect;
            }
            ENDCG
        }
    }
}
