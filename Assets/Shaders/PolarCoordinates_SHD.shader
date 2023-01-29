Shader "MyShaders/PolarCoordinates_SHD"
{
    Properties
    {
        //_Frequency("Frequency", float) = 5
        _MainTex("Main Texture", 2D) = "white" {}
        _CenterX("CenterX", float) = 0.5
        _CenterY("CenterY", float) = 0.5
        _RadialScale("Radial Scale", float) = 1
        _LengthScale("Lenght Scale", float) = 1
        
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

            //float _Frequency;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _CenterX;
            float _CenterY;
            float _RadialScale;
            float _LengthScale;

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
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex );

                return o;
            }

            float2 PolarCoordinates(float2 uv, float centerX, float centerY, float radialScale, float lenghtScale)
            {
                float2 centerXY = float2(centerX, centerY);
                float2 delta = uv - centerXY;
                float radius = length(delta) * 2 * radialScale;
                float angle = atan2(delta.x, delta.y) * 1.0/6.28 * lenghtScale;
                float2 t = float2(radius, angle);

                return t;
            }

            fixed4 frag (interpolators i) : SV_Target
            {
                float2 t = PolarCoordinates(i.uv, _CenterX, _CenterY, _RadialScale, _LengthScale);
                fixed4 o = tex2D(_MainTex, t);
                return o;
            }
            ENDCG
        }
    }
}
