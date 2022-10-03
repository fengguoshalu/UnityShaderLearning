// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Chapter-6/SpecularVertexLevel"
{
    Properties
    {
        _Diffuse("Color", Color) = (1,1,1,1)
        _Specular("Specular", Color) = (1, 1, 1, 1)
        _Gloss("Gloss", Range(8.0, 256)) = 20
    }
    SubShader
    {
        Pass{
            Tags {"LightMode" = "ForwardBase"}
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;

            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            
            struct v2f {
                float4 pos : SV_POSITION;
                fixed3 color : COLOR;
            };

            // 计算逐顶点光照
            v2f vert(a2v v) {
                v2f o;
                // 顶点变化
                o.pos = UnityObjectToClipPos(v.vertex);

                // ambient
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                // diffuse
                fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));

                // specular 
                fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);

                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);
                
                o.color = ambient + diffuse + specular;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                return fixed4(i.color, 1.0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}


// Shader "Custom/Chapter-6/SpecularVertexLevel"
// {
//     Properties{
//         _Color("Color", Color) = (1,1,1,1)
//         _Specular("Specular", Color) = (1, 1, 1, 1)
//         _Gloss("Gloss", Range(8.0, 256)) = 20
//     }
//     SubShader{
//         Pass {
//             Tags { "LightMode" = "ForwardBase" }
            
//             CGPROGRAM

//             #pragma vertex vert
//             #pragma fragment frag

//             #include "Lighting.cginc"
//             fixed4 _Diffuse;
//             struct a2v
//             {
//                 float4 vertex : POSITION;
//                 float3 normal : NORMAL;
//             };
//             struct v2f
//             {
//                 float4 pos : SV_POSITION;
//                 fixed3 color : NORMAL;
//             };

            

//             v2f vert(a2v v)
//             {
//                 v2f o;
//                 o.pos = UnityObjectToClipPos(v.vertex);

//                 // get ambient term
//                 fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

//                 // transfrom the normal from object space to world space
//                 fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

//                 // get the light direction in world space
//                 fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

//                 // compute diffuse term,  saturate limit value [0, 1]
//                 fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
//                 o.color = ambient + diffuse;
//                 return o;
//             }

//             fixed4 frag(v2f i) : SV_Target {
//                 return fixed4(i.color, 1.0);
//             }
            
//             ENDCG
            
//         }
//     }
    
//     Fallback "Diffuse"
// }
