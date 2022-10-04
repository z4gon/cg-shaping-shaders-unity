Shader "Unlit/5_CustomVertexData_Shader_Unlit"
{
    Properties
    {
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

            fixed4 frag (v2f i) : SV_Target
            {
                // transforms values like this: (0.5, -0.5, 0.0) to (1, -1 , 0)
                fixed3 position = i.position * 2;

                // saturate clamps values to (0, 1)
                fixed3 color = saturate(position);

                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
