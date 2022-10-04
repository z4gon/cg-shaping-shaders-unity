Shader "Unlit/14_MovedCircle_Shader_Unlit"
{
    Properties
    {
        _CircleRadius("Circle Radius", Range(0.0, 1.0)) = 0.3
        _CirclePosition("Circle Position", Vector) = (0,0,0,0)
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

            fixed4 frag (v2f i) : SV_Target
            {
                fixed inCircle = checkInCircle(i.position.xy, _CirclePosition, _CircleRadius);
                return fixed4(1,1,1,1) * inCircle;
            }
            ENDCG
        }
    }
}
