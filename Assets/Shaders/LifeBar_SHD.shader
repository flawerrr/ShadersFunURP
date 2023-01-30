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

            float InvesrseLerp(float a, float b, float t)
            {
                return (t-a)/(b-a);
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                // Capsule Sdf calculation
                float2 coords = float2( i.uv.x * 8, i.uv.y );
                float2 segment = float2( clamp( coords.x, 0.5, 7.5 ), 0.5) ;

                float sdf = distance( coords, segment ) - 0.5;
                float border =  step(sdf + 0.2, .1);
                clip( -sdf );
                

                
                float gradient = float( i.uv.x );

                float _tLife = saturate ( InvesrseLerp( 0.2, 0.8, _Life) );
                
                gradient = 1 - step( _Life, gradient );
                fixed4 barColor = lerp( _ColorA, _ColorB, _tLife ) ;

                fixed4 finalColor = barColor * gradient;
                
                //clip(gradient - 0.1);

                if( _Life < 0.2 )
                {
                    float flash = cos( _Time.y * 15 ) * 0.5 + 1;
                    finalColor *= flash;
                }
                
                finalColor = fixed4( finalColor.rgb, gradient );

                return lerp( 0, finalColor, border);

                return finalColor;
            }
            ENDCG
        }
    }
}
