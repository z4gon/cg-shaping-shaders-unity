Shader "Unlit/6_Step_Shader_Unlit"
{
    Properties
    {
        _StepEdge("Step Edge", Range(-1.0, 1.0)) = 0
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

            float _StepEdge;

            fixed4 frag (v2f i) : SV_Target
            {
                // transforms values like this: (0.5, -0.5, 0.0) to (1, -1 , 0)
                fixed3 color = i.position * 2;

                color.r = step(_StepEdge, color.r);
                color.g = step(_StepEdge, color.g);

                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
