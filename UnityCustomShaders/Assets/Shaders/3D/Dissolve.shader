
Shader "Custom/Dissolve"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
		_DissolveTex("Dissolve Texture", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		_LineColor("LineColor", Color) = (1,1,1,1)
		_DissolveVal("Dissolve Value", Range(-0.01, 1)) = 1.2
	}

	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
		}

		Pass{
			ColorMask 0
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Blend SrcColor OneMinusSrcColor

		CGPROGRAM
		#pragma exclude_renderers flash
		#pragma surface surf Lambert noforwardadd nolightmap noforwardadd novertexlights
		#include "UnitySprites.cginc"

		float4 _LineColor;
		float _DissolveVal;
		sampler2D _DissolveTex;

		struct Input
		{
			float2 uv_MainTex;
			fixed4 color;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4 c = SampleSpriteTexture(IN.uv_MainTex) * _Color;

			fixed4 dissolve = tex2D(_DissolveTex, IN.uv_MainTex);
			fixed4 clear = fixed4(0, 0, 0, 0);

			int isClear = int(dissolve.r - (_DissolveVal) + 0.99);
			int isAtLeastLine = int(dissolve.r - (_DissolveVal) + 0.99);

			fixed4 altCol = lerp(_LineColor, clear, isClear);

			o.Albedo = lerp(c.rgb, altCol, isAtLeastLine);
			o.Alpha = lerp(1.0, 0.0, isClear) * _Color.a;
			o.Emission = o.Alpha * _Color.a;
		}
		ENDCG
	}

	Fallback "Transparent/VertexLit"
}
