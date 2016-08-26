Shader "Custom/Example2"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_BDRFMap("BDRF Map", 2D) = "white"{}
	}
	
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct VertexIn
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct VertexOut
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float3 viewDir : TEXCOORD0;
			};
			
			VertexOut vert (VertexIn v)
			{
				VertexOut o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.viewDir = normalize(_WorldSpaceCameraPos - mul(_Object2World, v.vertex));
				return o;
			}

			float4 _Color;
			sampler2D _BDRFMap;

			fixed4 frag (VertexOut i) : SV_Target
			{
				float ndotv = 1 - dot(normalize(i.normal), i.viewDir);
				float ndotl = dot(normalize(i.normal), _WorldSpaceLightPos0);

				// Faux-BDRF with Texture Sample multiplied by Material Color
				return _Color * tex2D(_BDRFMap, float2(ndotl, ndotv));
			}
			ENDCG
		}
	}
}