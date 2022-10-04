# Cg Shaders for Unity

A collection of Shaders written in **Cg** for the **Built-in RP** in Unity, from basic to advanced.

### Course

[Learn Unity Shaders from Scratch - Nik Lever](https://www.udemy.com/course/learn-unity-shaders-from-scratch)

## Shaders

1. [Simple Red Unlit Shader](#simple-red-unlit-shader)
1. [Color Over Time](#color-over-time)
1. [With Exposed Properties in ShaderLab](#with-exposed-properties-in-shader-lab)
1. [Interpolated UVs](#interpolated-uvs)
1. [Custom Data from Vertex Shader](#custom-data-from-vertex-shader)
1. [Step and Smoothstep](#step-and-smoothstep)
1. [Circle](#circle)
1. [Square](#square)

## Simple Red Unlit Shader

- Simplest `Cg` Shader code.
- No fog or any lighting calculation.
- No Properties in `ShaderLab`.
- Just one `SubShader` with one `Pass`.
- No override for the `Vertex Shader`.
- Simply returns a `fixed4(1,0,0,1)` for all pixels.

```c
fixed4 frag (v2f_img i) : SV_Target
{
    return fixed4(1,0,0,1);
}
```

![Simple Red Unlit Shader](./docs/1.gif)

## Color Over Time

- Same structure as the simple red unlit shader.
- Uses the `sin()` and `cos()` functions to oscillate the colors.
- Uses the `Unity` `uniform` variable `_Time`, to change the color over time.

```c
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

![Color Over Time](./docs/2.gif)

## With Exposed Properties in ShaderLab

- Same structure as previous shaders.
- Exposes `_ColorA` and `_ColorB` to the Unity Editor, using `ShaderLab`.
- Uses the `lerp` function to blend between the two colors.

```c
Properties
{
    _ColorA("Color A", Color) = (1,0,0,1)
    _ColorB("Color B", Color) = (0,0,1,1)
}
SubShader
{
    // subshader code

    Pass
    {
        CGPROGRAM
        // pass code

        fixed4 _ColorA;
        fixed4 _ColorB;

        fixed4 frag (v2f_img i) : SV_Target
        {
            float delta = (sin(_Time.w) + 1) / 2;
            fixed3 color = lerp(_ColorA, _ColorB, delta);

            return fixed4(color, 1);

            // return _ColorA; // just Color A
            // return _ColorA.grba; // swaps Red with Green
        }
        ENDCG
    }
}
```

![ShaderLab Properties in the Unity Editor](./docs/shaderlab-properties.png)
![With Exposed Properties in ShaderLab](./docs/3.gif)

## Interpolated UVs

- Same structure as previous shaders.
- Uses the `i.uv.x` interpolated value coming from the `v2f_img` struct from the `Vertex Shader` as the delta.

```c
fixed4 frag (v2f_img i) : SV_Target
{
    float delta = i.uv.x;
    fixed3 color = lerp(_ColorA, _ColorB, delta);

    return fixed4(color, 1.0);
}
```

![Interpolated UVs](./docs/4.gif)

## Custom Data from Vertex Shader

- Defines a custom `struct` called `v2f` for "vertex to fragment".
- Uses the `Cg` semantics accordingly.
- Defines a function for the `Vertex Shader`.
- **Paints the pixels** by `saturating` the value of the interpolated for the pixel, on `Object Space`.
  - **Black** (0,0,0) in the left bottom, because object space coordinates there are (-0.5, -0.5) to (0,0), which after multiplying by 2 and then saturating, end up being (0,0,0)
  - **Green** (0,1,0) to **Yellow** (1,1,0) in the top, because object space coordinates there are (-0.5, 0.5) to (0.5, 0,5), which after multiplying by 2 and then saturating, end up being (0,1,0) to (1,1,0)
  - **Red** (1,0,0) to **Yellow** (1,1,0) in the right, because object space coordinates there are (0.5, -0.5) to (0.5, 0.5), which after multiplying by 2 and then saturating, end up being (1,0,0) to (1,1,0)

```c
struct v2f
{
    // Cg Semantics
    //      Binds Shader input/output to rendering hardware
    //      - SV_POSITION means system value position in DX10, corresponds to vertex position
    //      - TEXCOORDn means custom data

    float4 vertex: SV_POSITION; // From Object-Space to Clip-Space
    float4 position: TEXCOORD1;
    float4 uv: TEXCOORD0;
};

v2f vert (appdata_base v)
{
    v2f output;

    output.vertex = UnityObjectToClipPos(v.vertex);
    output.position = v.vertex;
    output.uv = v.texcoord;

    return output;
}

fixed4 frag (v2f i) : SV_Target
{
    // transforms values like this: (0.5, -0.5, 0.0) to (1, -1 , 0)
    fixed3 position = i.position * 2;

    // saturate clamps values to (0, 1)
    fixed3 color = saturate(position);

    return fixed4(color, 1.0);
}
```

![Custom Data from Vertex Shader](./docs/5.gif)

## Step and Smoothstep

- Same structure as previous shader.
- Uses `step()` to make the values be either 0 or 1, after passing the threshold, which is set to 0.
- Use `smoothstep()` to make the values be either 0 before first edge, or 1 after last edge, and an interpolation between 0 and 1 between edges.

```c
fixed4 frag (v2f i) : SV_Target
{
    // transforms values like this: (0.5, -0.5, 0.0) to (1, -1 , 0)
    fixed3 color = i.position * 2;

    color.r = step(_StepEdge, color.r);
    color.g = step(_StepEdge, color.g);

    return fixed4(color, 1.0);
}
```

![Step](./docs/6.gif)
![Parametrized Step](./docs/6-1.gif)

```c
fixed4 frag (v2f i) : SV_Target
{
    // transforms values like this: (0.5, -0.5, 0.0) to (1, -1 , 0)
    fixed3 color = i.position * 2;

    color.r = smoothstep(_EdgeStart, _EdgeEnd, color.r);
    color.g = smoothstep(_EdgeStart, _EdgeEnd, color.g);

    return fixed4(color, 1.0);
}
```

![Parametrized Smoothstep](./docs/6-2.gif)

## Circle

- Use `length()` to return a white pixel when the position of the pixel in object space is within the `_Radius`.
- `step()` to have 1 when outside the circle.
- Substract from 1 to invert the meaning, now 1 means inside the circle, multiply the final color by this.

```c
fixed4 frag (v2f i) : SV_Target
{
    fixed r = length(i.position.xy);
    fixed outCircle = step(_Radius, r);
    fixed inCircle = 1 - outCircle;

    return fixed4(1,1,1,1) * inCircle;
}
```

![Parametrized Smoothstep](./docs/7.gif)

## Square

- Use `checkInSquare()` to return 1 only if the pixel is inside the square.

```c
float checkInRect(float2 position, float2 center, float2 size)
{
    float2 p = position - center;

    float2 halfSize = size * 0.5;

    float horizontal = step(-halfSize.x, p.x) - step(halfSize.x, p.x);
    float vertical = step(-halfSize.y, p.y) - step(halfSize.y, p.y);

    return horizontal * vertical;
}

fixed4 frag (v2f i) : SV_Target
{
    float2 position = i.position.xy;
    fixed inRect = checkInRect(position, float2(_CenterX, _CenterY), _Size);

    return fixed4(1,1,1,1) * inRect;
}
```

![Parametrized Smoothstep](./docs/8.gif)
