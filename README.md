# Unity Shaders Practice
A collection of basic Shaders written in **Cg/HLSL** for the **Built-in RP** in Unity.
## Shaders
- [Simple Red Unlit Shader](#simple-red-unlit-shader)
- [Color over Time Unlit Shader](#color-over-time-unlit-shader)

## Simple Red Unlit Shader
- Simplest `Cg` Shader code.
- No fog or any lighting calculation.
- No Properties in `ShaderLab`.
- Just one `SubShader` with one `Pass`.
- No override for the `Vertex Shader`.
- Simply returns a `fixed4(1,0,0,1)` for all pixels.

```hlsl
fixed4 frag (v2f_img i) : SV_Target
{
    return fixed4(1,0,0,1);
}
```

![Simple Unlit Shader](./docs/1.gif)

## Color over Time Unlit Shader
- Same structure as the simple red unlit shader.
- Uses the `sin()` and `cos()` functions to oscillate the colors.
- Uses the `Unity` `uniform` variable `_Time`, to change the color over time.


```hlsl
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
```

![Simple Unlit Shader](./docs/2.gif)
