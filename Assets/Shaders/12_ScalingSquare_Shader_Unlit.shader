Shader "Unlit/12_ScalingSquare_Shader_Unlit"
{
    Properties
    {
        _SquarePosition("Square Position", Vector) = (0,0,0,0)
        _SquareAnchor("Square Anchor", Vector) = (0.15,0.15,0,0)
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

            float2 _SquarePosition;
            float2 _SquareAnchor;

            fixed4 frag (v2f i) : SV_Target
            {
                // rotation and scaling
                float2x2 rotation = getRotationMatrix2D(_Time.w);
                float2x2 scale = getScaleMatrix2D((sin(_Time.w) + 1)/3 + 0.5);
                float2x2 transform = mul(rotation, scale);

                // square measurements
                float2 size = 0.3;

                float2 position = i.position.xy * 2.0;

                // reposition the pixel at the center, rotate around zero, then put back in place
                float2 rotatedPos = mul(transform, position - _SquarePosition) + _SquarePosition;

                fixed inRect = checkInRect(rotatedPos, _SquarePosition, size, _SquareAnchor);

                return fixed4(1,1,0,1) * inRect;
            }
            ENDCG
        }
    }
}
