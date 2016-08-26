Shader "Custom/Example1"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white" {}
	}
	
	SubShader
	{
		Pass
		{
			/*
			* Code between the CGPROGRAM and ENDCG key words will be interpreted as CG code. Unity's ShaderLab syntax basically
			* changes part way through. It's a bit awkward, but in the block of code is where we can write vertex and fragment
			* in a format very similar to other graphics languages/APIs.
			*/
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			/*
			* This include gives us access to many built-in functions and macros, such as the TRANSFORM_TEX macro used below.
			* You can see the contents of the include folder and all the built in shaders by downloading the them from Unity's
			* download archive: https://unity3d.com/get-unity/download/archive
			*/
			#include "UnityCG.cginc"

			struct VertexIn
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct VertexOut
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;

			VertexOut vert (VertexIn v)
			{
				VertexOut o;
				/*
				* The MVP matrix is setup before this object is rendered. It's values are driven by the objects transform and
				* the properties of the camera that is currently rendering this object.
				*/
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
			    /*
				* The TRANSFORM_TEX Macro transform the uv coordinates to tile and offset based on the settings on the Material.
				* These tiling and offset functions are stored in "TextureName"_ST (eg: _MainTex_ST), and so _MainTexST must be
				* defined in the shader before the macro is used.
				*/
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			/*
			* The fragment program here just returns the texture sample at the given uv, multiplied by the provided color.
			*/
			fixed4 frag (VertexOut i) : SV_Target
			{
				return tex2D(_MainTex, i.uv) * _Color;
			}
			ENDCG
		}
	}
}