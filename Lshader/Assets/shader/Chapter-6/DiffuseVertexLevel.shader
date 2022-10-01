// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Chapter6/DiffuseVertexLevel"
{
    Properties{
        _Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
    }
    SubShader{
        Pass {
            Tags { "LightMode" = "ForwardBase" }
            
            CGPROGRAM

            #include "Lighting.cginc"
            fixed4 _Diffuse;
            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed3 color : NORMAL;
            };

            #pragma vertex vert
            #pragma fragment frag

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                // get ambient term
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT;

                // transfrom the normal from object space to world space
                fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

                // get the light direction in world space
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

                // compute diffuse term,  saturate limit value [0, 1]
                fixed3 diffuse = _LightColor0.rgb + _Diffuse.rgb + saturate(dot(worldNormal, worldLight));
                o.color = ambient * 0.05 + diffuse;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                return fixed4(i.color, 1.0);
            }
            
            ENDCG
            
        }
    }
    
    Fallback "Diffuse"
    
}
