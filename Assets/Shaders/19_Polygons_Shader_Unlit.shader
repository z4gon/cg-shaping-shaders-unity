Shader "Unlit/19_Polygons_Shader_Unlit"
{
    Properties
    {
        _Sides("Sides", Int) = 3
        _Radius("Radius", Float) = 0.3
        _Rotation("Rotation", Float) = 0
        _Center("Center", Vector) = (0,0,0,0)
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
            #include "./shared/Polygon.cginc"

            int _Sides;
            float _Radius;
            float _Rotation;
            float2 _Center;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 position = i.uv;

                // draw a polygon
                return fixed4(1,1,0,1) * polygon(position, _Center, _Radius, _Sides, _Rotation);
            }
            ENDCG
        }
    }
}
