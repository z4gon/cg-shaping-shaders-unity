Shader "Unlit/2_SimpleSinCosColor_Shader_Unlit"
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
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed redChannel = (sin(_Time.w) + 1) / 2;
                fixed blueChannel = (cos(_Time.w) + 1) / 2;

                fixed3 color = fixed3(redChannel, 0, blueChannel);

                return fixed4(color, 1); // oscillate between RED and BLUE

                // swizzling

                // return fixed4(color, 1).gbra; // oscillate between GREEN and BLUE
                // return fixed4(color, 1).rrra; // gray scale
                // return fixed4(color, 1).xxxw; // gray scale
            }
            ENDCG
        }
    }
}
