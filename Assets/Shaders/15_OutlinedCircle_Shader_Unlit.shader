Shader "Unlit/15_OutlinedCircle_Shader_Unlit"
{
    Properties
    {
        _CircleRadius("Circle Radius", Range(0.0, 1.0)) = 0.3
        _CirclePosition("Circle Position", Vector) = (0,0,0,0)
        _LineWidth("Line Width", Float) = 0.2
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
            #include "./shared/SimpleV2F.cginc"
            #include "./shared/Circle.cginc"

            float _CircleRadius;
            float2 _CirclePosition;
            float _LineWidth;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed inCircle = circle(i.position.xy, _CirclePosition, _CircleRadius, _LineWidth);
                return fixed4(1,1,1,1) * inCircle;
            }
            ENDCG
        }
    }
}
