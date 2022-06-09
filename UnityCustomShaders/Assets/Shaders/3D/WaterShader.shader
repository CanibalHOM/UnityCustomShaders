Shader "Custom/WaterShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
		_BumpMap("Bumpmap", 2D) = "bump" {}
		_Cube("Cubemap", CUBE) = "" {}
		
		_Frequency("Frequency", Range(0, 5)) = 2
		_Amplitude("Amplitude", Range(-0.5,0.5)) = 1
		_Speed("Speed",Range(1, 80)) = 5

		_DistortStrength("Distortion Strength", float) = 0.5
		_Emission("Emission", float) = 1.0

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

		LOD 200

		ZWrite On
		ZTest Less
		Cull Back 
		Lighting Off
		Fog { Mode Off }
		Blend SrcAlpha OneMinusSrcAlpha

		GrabPass {}

		CGPROGRAM
		#pragma surface surf Lambert alpha vertex:vert 
		#pragma target 3.0

		sampler2D _GrabTexture;

		struct Input
		{
			float2 uv_MainTex;
			float4 uv_GrabTexture;
			float2 uv_BumpMap;
			float3 worldRefl;
			float4 grabUV;
			INTERNAL_DATA

			fixed offset;
			fixed4 color : COLOR;
		};

		UNITY_INSTANCING_BUFFER_START(Props)

		sampler2D _MainTex;
		sampler2D _BumpMap;
		samplerCUBE _Cube;

		half _Frequency;
		half _Amplitude;
		half _Speed;
		half _DistortStrength;
		half _Emission;

		fixed4 _Color;

		UNITY_INSTANCING_BUFFER_END(Props)

		void vert(inout appdata_full v, out Input o)
		{

			fixed time = _Time.x * _Speed;
			fixed frequency = _Frequency;
			fixed amplitude = _Amplitude;

			fixed offset = cos(v.vertex.x * frequency + time) + sin(v.vertex.z * frequency + time);
			v.vertex.y = offset * amplitude;
			
			float4 hpos = UnityObjectToClipPos(v.vertex);
			hpos.x += offset * amplitude * _DistortStrength;

			UNITY_INITIALIZE_OUTPUT(Input, o);

			o.grabUV = ComputeGrabScreenPos(hpos);
			o.offset = offset;

		}

		void surf(Input IN, inout SurfaceOutput o)
		{
			float4 uv = UNITY_PROJ_COORD(IN.grabUV);
			fixed4 grabColor = tex2Dproj(_GrabTexture, uv);

			o.Albedo = grabColor.rgb;

			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			o.Emission = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal)).rgb * _Emission;

			o.Alpha = _Color.a;
		}
			
		ENDCG
		
	}

   FallBack "Diffuse"

}
