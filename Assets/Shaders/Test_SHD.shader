Shader "MyShaders/Test_SHD"
{
    Properties
    {
        _ColorA("ColorA", color) = (1,1,1,1)
        _ColorB("ColorB", color) = (1,1,1,1)
        _scale0("Scale0", range(0,1)) = 0
        _scale1("Scale1", range(0,1)) = 1
        _frequency("Frequency", float) = 5
    }
    SubShader
    {
        Tags { 
            "RenderType"="Transparent"
            "Queue"="Transparent" 
            }

        Pass
        {
            Cull Off
            Blend SrcAlpha DstAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #define TAU 6.28319

            float4 _ColorA;
            float4 _ColorB;
            float _scale0;
            float _scale1;
            float _frequency;

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct interpolators
            {
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            float inverseLerp(float a, float b, float t){
                return (t-a)/(b-a);
            }
            
            interpolators vert (MeshData v)
            {
                interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = (v.normal);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (interpolators i) : SV_Target
            {
                float offset = cos(i.uv.y * TAU * 5);
                float t = cos(i.uv.x * TAU * _frequency + offset + _Time.w)/2 + 0.5;
                return fixed4(t,t,t,t);
                
                float3 normals = i.normal;
                return fixed4(normals.xyz, 1);
            }
            ENDCG
        }
    }
}
