Shader "Custom/Example3"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	}

	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct VertIn
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct VertOut
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			VertOut vert(VertIn v)
			{
				VertOut o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}

			#define PI 3.14159265359

			float2 Plasma(float2 uv)
			{
				float v = 0.0;
				float2 c = uv * 20 - 10;
				v += sin(c.x + _Time.y * -0.5);
				v += sin((c.x + c.y + _Time.y) / 2.0);
				c += float2(sin(_Time.y / 3.0), cos(_Time.y / 2.0));
				v += sin(sqrt(c.x*c.x + c.y*c.y + 1.0) + _Time.y);
				v = v / 3.0;

				return float2((sin(PI*v * 4) + 1) * 0.5, (cos(PI*v * 4) + 1) * 0.5);
			}

			sampler2D _MainTex;
			float _Magnitude;

			fixed4 frag(VertOut i) : SV_Target
			{
				_Magnitude = 0.002;
				float2 offset = Plasma(i.uv);
				
				offset = offset * 2 - 1;

				fixed4 col = tex2D(_MainTex, i.uv + offset * _Magnitude);
				return col;
			}
			ENDCG
		}
	}
}
