Shader "Custom/TransparentAndGlow" 
{

	Properties
	{
		[PerRendererData] _MainTex("Texture", 2D) = "white" {}
		
		_Color("Color", Color) = (1, 1, 1, 1)
		_GlowColor("Glow Color", Color) = (0.26, 0.19, 0.16, 0.0)
		
		_Glow("Glow", Range(0.5, 8.0)) = 3.0
		_Alpha("Transparent",  Range(0.0, 1)) = 1
	}

	SubShader
	{
		Tags
		{ 
			"Queue" = "Transparent+1" 
			"IgnoreProjector" = "True" 
			"RenderType" = "Transparent"
		}
		
		Pass
		{
			ColorMask 0
		}

		Blend SrcColor OneMinusSrcColor

		CGPROGRAM
		#pragma exclude_renderers flash
		#pragma surface surf Lambert noforwardadd

		struct Input 
		{
			float2 uv_MainTex;
			float3 viewDir;
		};

		sampler2D _MainTex;

		float4 _GlowColor;
		float4 _Color;

		float _Glow;
		float _Alpha;

		void surf(Input IN, inout SurfaceOutput o) {
			
			half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Alpha * _Color.a;

			o.Albedo = c.rgb;
			o.Alpha = c.a;

			half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
			o.Emission = _GlowColor.rgb * pow(rim, _Glow) * _Color.a;
		}

		ENDCG
	}
}