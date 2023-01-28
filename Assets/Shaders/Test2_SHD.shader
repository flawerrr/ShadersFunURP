Shader "MyShaders/Test2_SHD"
{
    Properties
    {
        _Frequency("Frequency", float) = 5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #define TAU 6.28319

            float1 _Frequency;

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
            

            interpolators vert (MeshData v)
            {
                interpolators o;

                float t = cos(v.uv.x * TAU * _Frequency + _Time.w) * 0.5 + 0.5;
                float s = cos(v.uv.y * TAU * _Frequency + _Time.w) * 0.5 + 0.5;
                v.vertex.y = t*s;
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (interpolators i) : SV_Target
            {
                float t = cos(i.uv.x * TAU * _Frequency) * 0.5 + 0.5;
                float s = cos(i.uv.y * TAU * _Frequency) * 0.5 + 0.5;
                return t*s;
                
            }
            ENDCG
        }
    }
}
