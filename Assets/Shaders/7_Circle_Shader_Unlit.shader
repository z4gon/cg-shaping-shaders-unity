Shader "Unlit/7_Circle_Shader_Unlit"
{
    Properties
    {
        _Radius("Radius", Range(0.0, 1.0)) = 0.3
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

            float _Radius;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed inCircle = circle(i.position.xy, float2(0,0), _Radius);
                return fixed4(1,1,1,1) * inCircle;
            }
            ENDCG
        }
    }
}
