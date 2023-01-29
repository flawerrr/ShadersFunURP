Shader "MyShaders/LifeBar_SHD"
{
    Properties
    {
        _ColorA("Color A", color) = (0,0,0,1)
        _ColorB("Color B", color) = (1,1,1,1)
        _Life("Life", range( 0, 1 )) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float4 _ColorA;
            float4 _ColorB;
            float _Life;

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
            

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                float gradient = float2( i.uv );
                gradient = 1 - step( _Life, gradient );
                fixed4 barColor = lerp(_ColorA, _ColorB, _Life) ;

                fixed4 finalColor = barColor * gradient;
                finalColor = fixed4(finalColor.rgb, gradient);

                return finalColor;
            }
            ENDCG
        }
    }
}
