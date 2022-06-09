
Shader "Custom/Outline" {

	Properties{
		_OutlineColor("Outline Color", Color) = (0,0,0,1)
		_Color("Color", Color) = (0,0,0,1)
		_Metallic("Metallic width", Range(-100, 100)) = -30
		_Glossiness("Glossiness width", Range(-100, 100)) = -5
		_EmissionPower("Emission power", Range(0, 1)) = 0.25
		_OutlineWidth("Outline size", Range(0, 0.5)) = 0.03
		_DamageRange("Damage Range", Range(0, 1)) = 0
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
			Cull Off
			ZWrite Off
			LOD 300

			CGPROGRAM

			#pragma surface surf Lambert vertex:vert 

			struct Input
			{
				float4 position : SV_POSITION;
				float3 worldPos;
			};

			fixed4 _OutlineColor;
			float _EmissionPower;
			half _DamageRange;
			float _OutlineWidth;

			void vert(inout appdata_full v)
			{
				v.vertex.xyz += v.normal.xyz * _OutlineWidth * 2;
			}

			void surf(Input IN, inout SurfaceOutput o)
			{
				o.Albedo	= _OutlineColor.rgb;
				o.Emission	= _EmissionPower;

				clip(frac((IN.worldPos) * 5) - _DamageRange);
			}

			ENDCG

			Cull Off
			ZWrite On
			ZTest LEqual
			LOD 300
			CGPROGRAM

			#pragma surface surf Lambert

			struct Input
			{
				float4 position : SV_POSITION;
				float3 worldPos;
			};

			fixed4 _OutlineColor;
			float _EmissionPower;
			half _DamageRange;

			void surf(Input IN, inout SurfaceOutput o)
			{
				o.Albedo	= _OutlineColor.rgb;
				o.Emission	= _EmissionPower;

				clip(frac((IN.worldPos) * 5) - _DamageRange);
			}

			ENDCG

			CGPROGRAM

			#pragma surface surf Standard vertex:vert 

			struct Input
			{
				float4 position : SV_POSITION;
				float3 worldPos;
			};

			float4 _Color;

			float _OutlineWidth;
			float _ModelSize;

			float _Metallic;
			float _Glossiness;

			half _DamageRange;

			void vert(inout appdata_full v)
			{
				v.vertex.xyz += float3(v.normal.xyz) *_OutlineWidth;
			}

			void surf(Input IN, inout SurfaceOutputStandard o)
			{
				o.Albedo = _Color.rgb;
				o.Metallic = _Metallic;
				o.Smoothness = _Glossiness;

				clip(frac((IN.worldPos) * 15) - _DamageRange);
			}
		
			ENDCG
	}

}