# Cg Shapes Shaders for Unity

A collection of Shapes Shaders written in **Cg** for the **Built-in RP** in Unity, from basic to advanced.

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
1. [Square and Rectangle](#square-and-rectangle)
1. [Follow Mouse](#follow-mouse)
1. [Moving Square](#moving-square)
1. [Rotating Square](#rotating-square)
1. [Scaling Square](#scaling-square)
1. [Tiling](#tiling)
1. [Moved Circle](#moved-circle)

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

![Parametrized Smoothstep](./docs/61.gif)

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

![Circle](./docs/7.gif)

## Square and Rectangle

- Use `checkInRect()` to return 1 only if the pixel is inside the square.

```c
float checkInRect(float2 position, float2 center, float2 size)
{
    // returns 1 when the position is inside the rect defined by center and size
    float2 p = position - center;

    float2 halfSize = size * 0.5;

    // 0 if less than -halfSize, 1 if between -halfSize and halfSize, 0 if over halfSize
    float2 test = step(-halfSize, p) - step(halfSize, p);

    return test.x * test.y;
}

fixed4 frag (v2f i) : SV_Target
{
    float2 position = i.position.xy;
    fixed inRect = checkInRect(position, float2(_CenterX, _CenterY), float2(_Width, _Height));

    return fixed4(1,1,1,1) * inRect;
}
```

![Square](./docs/8.gif)
![Rect](./docs/81.gif)

```c
fixed4 frag (v2f i) : SV_Target
{
    float2 position = i.position.xy;
    fixed inRect1 = checkInRect(position, _Rect1.xy, _Rect1.zw);
    fixed inRect2 = checkInRect(position, _Rect2.xy, _Rect2.zw);

    return _Color1 * inRect1 + _Color2 * inRect2;
}
```

![2 Rects](./docs/82.gif)

## Follow Mouse

- Use `checkInRect()` but with a square based on the mouse position as center.
- Use a **C#** script to **RayCast** on top of the **Quad**, then **pass** the Mouse Position to the **Material**.

```cs
void Update()
{
    // Raycast
    RaycastHit hit;
    var ray = _camera.ScreenPointToRay(Input.mousePosition);

    if (Physics.Raycast(ray, out hit))
    {
        _mousePosition = hit.textureCoord;
    }

    _material.SetVector("_MousePosition", _mousePosition);
}
```

```c
fixed4 frag (v2f i) : SV_Target
{
    float2 position = i.uv;
    fixed inRect = checkInRect(position, _MousePosition.xy, float2(0.1, 0.1));

    return fixed4(1,1,0,1) * inRect;
}
```

![Follow Mouse](./docs/9.gif)

## Moving Square

- Use `checkInRect()` but using `sin` and `cos` to position the rectangle.

```c
fixed4 frag (v2f i) : SV_Target
{
    float movementRadius = 0.3;

    // square measurements
    float2 center = float2(cos(_Time.w),sin(_Time.w)) * movementRadius;
    float2 size = 0.2;

    float2 position = i.position.xy * 2.0;

    fixed inRect = checkInRect(position, center, size);

    return fixed4(1,1,0,1) * inRect;
}
```

![Moving Square](./docs/10.gif)

## Rotating Square

- Use a 2D `rotation matrix` to rotate the pixel position.

```c
float2x2 getRotationMatrix2D(float theta)
{
    float s = sin(theta);
    float c = cos(theta);

    return float2x2(c,-s,s,c);
}

fixed4 frag (v2f i) : SV_Target
{
    // rotation
    float2x2 rotation = getRotationMatrix2D(_Time.w);

    // square measurements
    float2 size = 0.5;

    float2 position = i.position.xy * 2.0;

    // reposition the pixel at the center, rotate around zero, then put back in place
    float2 rotatedPos = mul(rotation, position - _SquarePosition) + _SquarePosition;

    fixed inRect = checkInRect(rotatedPos, _SquarePosition, size);

    return fixed4(1,1,0,1) * inRect;
}
```

![Rotating Square](./docs/11.gif)

### Change Anchor

```c
float checkInRect(float2 position, float2 center, float2 size, float2 anchor = 0)
{
    // returns 1 when the position is inside the rect defined by center and size
    float2 p = position - center;

    float2 halfSize = size * 0.5;

    // 0 if less than -halfSize, 1 if between -halfSize and halfSize, 0 if over halfSize
    float2 test = step(-halfSize - anchor, p) - step(halfSize - anchor, p);

    return test.x * test.y;
}

```

![Anchor for Square](./docs/11b.gif)

## Scaling Square

- Use a 2D `scaling matrix` to scale the pixel position.
- Multiply the `rotation matrix` by the `scale matrix`, to generate a new `transform matrix`.

```c
float2x2 getScaleMatrix2D(float scale)
{
    return float2x2(scale,0,0,scale);
}

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
```

![Scaling Square](./docs/12.gif)

## Tiling

- Use `frac()` from **Cg** to extract the fractional component of the decimal values for UVs.
- This essentialy replicates many coordinate systems of `(0,0) to (1,1)` across the Quad.
- The calculations for the rotating square are still done in a `(0,0) to (1,1)` coordinate system.
- So, this basically clones the same thing we did before, but as many times as `Tile Count` states.
- `Tile Count` can have different values for `x` and `y`, distoring the tiles.

```c
fixed4 frag (v2f i) : SV_Target
{
    // rotation and scaling
    float2x2 rotation = getRotationMatrix2D(_Time.w);
    float2x2 scale = getScaleMatrix2D((sin(_Time.w) + 1)/3 + 0.5);
    float2x2 transform = mul(rotation, scale);

    // square measurements
    float2 size = 0.3;

    float2 position = frac(i.uv * _TileCount);

    // reposition the pixel at the center, rotate around zero, then put back in place
    float2 rotatedPos = mul(transform, position - _SquarePosition) + _SquarePosition;

    fixed inRect = checkInRect(rotatedPos, _SquarePosition, size, _SquareAnchor);

    return fixed4(1,1,0,1) * inRect;
}
```

![Tiling](./docs/13.gif)

## Moved Circle

- Use a vector to set a position for the center of the circle, and calculate around it.

```c
float checkInCircle(float2 position, float2 center, float radius)
{
    // returns 1 if the point is inside the circle defined by center and radius

    fixed r = length(position - center);
    fixed outCircle = step(radius, r);
    fixed inCircle = 1 - outCircle;

    return inCircle;
}

fixed4 frag (v2f i) : SV_Target
{
    fixed inCircle = checkInCircle(i.position.xy, _CirclePosition, _CircleRadius);
    return fixed4(1,1,1,1) * inCircle;
}
```

![Moved Circle](./docs/14.gif)

### Soft Circle

- Use a `[Toggle]` property in `ShaderLab` to enable or disable the softness in the circle.
- Add a `smoothstep()` to the `checkInCircle()`

```c
float checkInCircle(float2 position, float2 center, float radius, bool soften = false)
{
    // returns 1 if the point is inside the circle defined by center and radius

    fixed r = length(position - center);

    float softenThreshold = soften ? radius * 0.2 : 0.0;

    fixed outCircle = smoothstep(radius - softenThreshold, radius + softenThreshold, r);
    fixed inCircle = 1 - outCircle;

    return inCircle;
}
```

```c
Properties
{
    // ...
    [Toggle] _Soften("Soften", Float) = 0
}
```

```c
fixed4 frag (v2f i) : SV_Target
{
    fixed inCircle = checkInCircle(i.position.xy, _CirclePosition, _CircleRadius, _Soften);
    return fixed4(1,1,1,1) * inCircle;
}
```

![Soft Circle](./docs/14b.gif)

### Outlined Circle

- Use `step()` to check if the pixel is inside the circle outline.

```c
float checkInCircle(float2 position, float2 center, float radius, float lineWidth)
{
    // returns 1 if the point is inside the circle line width

    fixed r = length(position - center);

    fixed inCircle = step(radius - lineWidth, r) - step(radius + lineWidth, r);

    return inCircle;
}
```

```c
fixed4 frag (v2f i) : SV_Target
{
    fixed inCircle = checkInCircle(i.position.xy, _CirclePosition, _CircleRadius, _LineWidth);
    return fixed4(1,1,1,1) * inCircle;
}
```

![Outlined Circle](./docs/14c.gif)
