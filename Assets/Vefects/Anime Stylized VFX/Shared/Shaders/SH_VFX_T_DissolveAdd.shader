// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "/_Vefects_/T/SH_VFX_Vefects_DissolveAdd"
{
	Properties
	{
		_Texture("Texture", 2D) = "white" {}
		_TextureChannel("Texture Channel", Vector) = (0,1,0,0)
		_TextureRotation("Texture Rotation", Float) = 0
		_ColorTexture("Color Texture", 2D) = "white" {}
		_ColorRotation("Color Rotation", Float) = 0
		_GradientShape("Gradient Shape", 2D) = "white" {}
		_GradientShapeChannel("Gradient Shape Channel", Vector) = (0,1,0,0)
		_GradientShapeRotation("Gradient Shape Rotation", Float) = 0
		_DissolveMask("Dissolve Mask", 2D) = "white" {}
		_DistoMask("Disto Mask", 2D) = "white" {}
		_DissolveMaskChannel("Dissolve Mask Channel", Vector) = (0,1,0,0)
		_DistoMaskChannel("Disto Mask Channel", Vector) = (0,1,0,0)
		_DissolveMaskRotation("Dissolve Mask Rotation", Float) = 0
		_DistoMaskRotation("Disto Mask Rotation", Float) = 0
		_DissolveMaskInvert("Dissolve Mask Invert", Range( 0 , 1)) = 0
		_GradientMap("Gradient Map", 2D) = "white" {}
		_GradientMapDisplacement("Gradient Map Displacement", Float) = 0.1
		_TexturePanSpeed("Texture Pan Speed", Vector) = (0,0,0,0)
		_DistoMaskPanSpeed("Disto Mask Pan Speed", Vector) = (0,0,0,0)
		_DissolveMaskPanSpeed("Dissolve Mask Pan Speed", Vector) = (0,0,0,0)
		_InvertGradient("Invert Gradient", Float) = 0
		_CorePower("Core Power", Float) = 1
		_CoreIntensity("Core Intensity", Float) = 0
		_DifferentCoreColor("Different Core Color", Float) = 0
		_CoreColor("Core Color", Color) = (1,1,1,0)
		_GlowIntensity("Glow Intensity", Float) = 1
		_Brightness("Brightness", Float) = 1
		_AlphaBoldness("Alpha Boldness", Float) = 1
		_CameraDirPush("CameraDirPush", Float) = 0
		[Toggle(_CUSTOMPANSWITCH_ON)] _CustomPanSwitch("CustomPanSwitch", Float) = 0
		[Toggle(_MESHVERTEXCOLOR_ON)] _MeshVertexColor("MeshVertexColor", Float) = 0
		_Dissolve("Dissolve", Float) = 0
		[Toggle(_STEP_ON)] _Step("Step", Float) = 0
		_ValueStep("ValueStep", Float) = 0
		_ValueStepAdd("ValueStepAdd", Float) = 0.1
		_Disto("Disto", Float) = 0
		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _CUSTOMPANSWITCH_ON
		#pragma shader_feature_local _STEP_ON
		#pragma shader_feature_local _MESHVERTEXCOLOR_ON
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 worldPos;
			float4 uv_texcoord;
			float2 uv2_texcoord2;
			float2 uv4_texcoord4;
			float4 vertexColor : COLOR;
		};

		uniform float _CameraDirPush;
		uniform sampler2D _ColorTexture;
		uniform float4 _ColorTexture_ST;
		uniform float _ColorRotation;
		uniform sampler2D _DistoMask;
		uniform float4 _DistoMask_ST;
		uniform float _DistoMaskRotation;
		uniform float2 _DistoMaskPanSpeed;
		uniform float4 _DistoMaskChannel;
		uniform float _Disto;
		uniform sampler2D _GradientMap;
		uniform sampler2D _GradientShape;
		uniform float4 _GradientShape_ST;
		uniform float _GradientShapeRotation;
		uniform float4 _GradientShapeChannel;
		uniform sampler2D _DissolveMask;
		uniform float4 _DissolveMask_ST;
		uniform float _DissolveMaskRotation;
		uniform float2 _DissolveMaskPanSpeed;
		uniform float4 _DissolveMaskChannel;
		uniform float _DissolveMaskInvert;
		uniform float _Dissolve;
		uniform float _InvertGradient;
		uniform float _GradientMapDisplacement;
		uniform float4 _CoreColor;
		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform float _TextureRotation;
		uniform float2 _TexturePanSpeed;
		uniform float4 _TextureChannel;
		uniform float _CorePower;
		uniform float _CoreIntensity;
		uniform float _DifferentCoreColor;
		uniform float _Brightness;
		uniform float _GlowIntensity;
		uniform float _AlphaBoldness;
		uniform float _ValueStep;
		uniform float _ValueStepAdd;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			v.vertex.xyz += ( ( ase_worldPos - _WorldSpaceCameraPos ) * ( ( _CameraDirPush + v.texcoord3.xy.y ) * 0.01 ) );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 uvs_ColorTexture = i.uv_texcoord;
			uvs_ColorTexture.xy = i.uv_texcoord.xy * _ColorTexture_ST.xy + _ColorTexture_ST.zw;
			float cos48 = cos( radians( _ColorRotation ) );
			float sin48 = sin( radians( _ColorRotation ) );
			float2 rotator48 = mul( uvs_ColorTexture.xy - float2( 0.5,0.5 ) , float2x2( cos48 , -sin48 , sin48 , cos48 )) + float2( 0.5,0.5 );
			float2 temp_cast_0 = (0.0).xx;
			#ifdef _CUSTOMPANSWITCH_ON
				float2 staticSwitch113 = i.uv2_texcoord2;
			#else
				float2 staticSwitch113 = temp_cast_0;
			#endif
			float2 CustomUV111 = staticSwitch113;
			float4 uvs_DistoMask = i.uv_texcoord;
			uvs_DistoMask.xy = i.uv_texcoord.xy * _DistoMask_ST.xy + _DistoMask_ST.zw;
			float cos155 = cos( radians( _DistoMaskRotation ) );
			float sin155 = sin( radians( _DistoMaskRotation ) );
			float2 rotator155 = mul( uvs_DistoMask.xy - float2( 0.5,0.5 ) , float2x2( cos155 , -sin155 , sin155 , cos155 )) + float2( 0.5,0.5 );
			float dotResult149 = dot( tex2D( _DistoMask, ( rotator155 + uvs_DistoMask.w + CustomUV111 + ( _Time.y * _DistoMaskPanSpeed ) ) ) , _DistoMaskChannel );
			float Disto161 = ( saturate( dotResult149 ) * _Disto );
			float4 uvs_GradientShape = i.uv_texcoord;
			uvs_GradientShape.xy = i.uv_texcoord.xy * _GradientShape_ST.xy + _GradientShape_ST.zw;
			float cos19 = cos( radians( _GradientShapeRotation ) );
			float sin19 = sin( radians( _GradientShapeRotation ) );
			float2 rotator19 = mul( uvs_GradientShape.xy - float2( 0.5,0.5 ) , float2x2( cos19 , -sin19 , sin19 , cos19 )) + float2( 0.5,0.5 );
			float dotResult25 = dot( tex2D( _GradientShape, ( rotator19 + CustomUV111 + Disto161 ) ) , _GradientShapeChannel );
			float4 uvs_DissolveMask = i.uv_texcoord;
			uvs_DissolveMask.xy = i.uv_texcoord.xy * _DissolveMask_ST.xy + _DissolveMask_ST.zw;
			float cos6 = cos( radians( _DissolveMaskRotation ) );
			float sin6 = sin( radians( _DissolveMaskRotation ) );
			float2 rotator6 = mul( uvs_DissolveMask.xy - float2( 0.5,0.5 ) , float2x2( cos6 , -sin6 , sin6 , cos6 )) + float2( 0.5,0.5 );
			float dotResult10 = dot( tex2D( _DissolveMask, ( rotator6 + uvs_DissolveMask.w + CustomUV111 + ( _Time.y * _DissolveMaskPanSpeed ) + Disto161 ) ) , _DissolveMaskChannel );
			float temp_output_13_0 = saturate( dotResult10 );
			float lerpResult22 = lerp( temp_output_13_0 , saturate( ( 1.0 - temp_output_13_0 ) ) , _DissolveMaskInvert);
			float temp_output_26_0 = ( saturate( lerpResult22 ) + i.uv_texcoord.z + _Dissolve );
			float temp_output_33_0 = saturate( ( saturate( dotResult25 ) * temp_output_26_0 ) );
			float lerpResult43 = lerp( saturate( ( 1.0 - temp_output_33_0 ) ) , temp_output_33_0 , _InvertGradient);
			float2 temp_cast_4 = (( lerpResult43 + _GradientMapDisplacement )).xx;
			float3 temp_output_60_0 = (i.vertexColor).rgb;
			float3 temp_output_63_0 = ( saturate( ( (tex2D( _ColorTexture, ( rotator48 + CustomUV111 + Disto161 ) )).rgb + i.uv4_texcoord4.x ) ) * (tex2D( _GradientMap, temp_cast_4 )).rgb * temp_output_60_0 );
			float4 uvs_Texture = i.uv_texcoord;
			uvs_Texture.xy = i.uv_texcoord.xy * _Texture_ST.xy + _Texture_ST.zw;
			float cos34 = cos( radians( _TextureRotation ) );
			float sin34 = sin( radians( _TextureRotation ) );
			float2 rotator34 = mul( uvs_Texture.xy - float2( 0.5,0.5 ) , float2x2( cos34 , -sin34 , sin34 , cos34 )) + float2( 0.5,0.5 );
			float dotResult38 = dot( tex2D( _Texture, ( rotator34 + ( _Time.y * _TexturePanSpeed ) + CustomUV111 + Disto161 ) ) , _TextureChannel );
			float temp_output_50_0 = ( temp_output_26_0 * saturate( dotResult38 ) );
			float temp_output_59_0 = ( pow( temp_output_50_0 , _CorePower ) * _CoreIntensity );
			float4 lerpResult67 = lerp( float4( temp_output_63_0 , 0.0 ) , _CoreColor , saturate( temp_output_59_0 ));
			float4 lerpResult74 = lerp( float4( temp_output_63_0 , 0.0 ) , saturate( lerpResult67 ) , _DifferentCoreColor);
			float4 temp_output_79_0 = ( saturate( lerpResult74 ) * _Brightness );
			o.Emission = temp_output_79_0.rgb;
			float3 temp_cast_9 = (1.0).xxx;
			#ifdef _MESHVERTEXCOLOR_ON
				float3 staticSwitch126 = temp_output_60_0;
			#else
				float3 staticSwitch126 = temp_cast_9;
			#endif
			float3 temp_output_78_0 = saturate( ( ( i.vertexColor.a * saturate( ( temp_output_59_0 + ( temp_output_50_0 * _GlowIntensity ) ) ) * staticSwitch126 ) * _AlphaBoldness ) );
			float3 temp_cast_10 = (_ValueStep).xxx;
			float3 temp_cast_11 = (( _ValueStep + _ValueStepAdd )).xxx;
			float3 smoothstepResult129 = smoothstep( temp_cast_10 , temp_cast_11 , temp_output_78_0);
			#ifdef _STEP_ON
				float3 staticSwitch130 = saturate( smoothstepResult129 );
			#else
				float3 staticSwitch130 = temp_output_78_0;
			#endif
			o.Alpha = staticSwitch130.x;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float4 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xyzw = customInputData.uv_texcoord;
				o.customPack1.xyzw = v.texcoord;
				o.customPack2.xy = customInputData.uv2_texcoord2;
				o.customPack2.xy = v.texcoord1;
				o.customPack2.zw = customInputData.uv4_texcoord4;
				o.customPack2.zw = v.texcoord3;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xyzw;
				surfIN.uv2_texcoord2 = IN.customPack2.xy;
				surfIN.uv4_texcoord4 = IN.customPack2.zw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18921
19;54;2517;1272;2200.192;928.5625;1.22905;True;False
Node;AmplifyShaderEditor.CommentaryNode;115;-4655.81,-1210.096;Inherit;False;820.0869;299.5054;PanInCustomUV;4;110;113;114;111;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;168;-3684.031,-1984.529;Inherit;False;2094.472;760.8214;Disto;18;150;146;153;154;152;151;156;157;158;155;159;147;148;149;160;164;163;161;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;110;-4605.81,-1069.591;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;114;-4542.313,-1160.096;Inherit;False;Constant;_Value0;Value0;26;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;113;-4337.313,-1074.096;Inherit;False;Property;_CustomPanSwitch;CustomPanSwitch;30;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-3394.367,-1697.842;Inherit;False;Property;_DistoMaskRotation;Disto Mask Rotation;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;146;-3634.031,-1934.529;Inherit;True;Property;_DistoMask;Disto Mask;9;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RadiansOpNode;152;-3131.163,-1675.38;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;151;-3072.677,-1387.708;Inherit;False;Property;_DistoMaskPanSpeed;Disto Mask Pan Speed;19;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;153;-3063.677,-1459.709;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;154;-3267.162,-1828.38;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;-4059.725,-1067.236;Inherit;False;CustomUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;-2816.677,-1462.708;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;156;-3393.52,-1597.272;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;157;-2950.092,-1587.232;Inherit;False;111;CustomUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;155;-2968.163,-1819.38;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;159;-2716.954,-1817.164;Inherit;False;4;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;148;-2536.271,-1902.532;Inherit;True;Property;_TextureSample5;Texture Sample 5;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;147;-2461.358,-1691.042;Inherit;False;Property;_DistoMaskChannel;Disto Mask Channel;11;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;149;-2192.15,-1839.47;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;105;-5979.15,-114.1653;Inherit;False;2848.594;729.824;Dissolve Mask;24;13;15;18;26;23;22;17;10;9;8;7;6;4;1;3;2;5;90;92;91;24;116;128;166;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;160;-1977.598,-1849.934;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;164;-2194.119,-1690.495;Inherit;False;Property;_Disto;Disto;36;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-5659.369,140.5245;Inherit;False;Property;_DissolveMaskRotation;Dissolve Mask Rotation;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;-5929.15,-60.98477;Inherit;True;Property;_DissolveMask;Dissolve Mask;8;0;Create;True;0;0;0;False;0;False;None;249b5f66597eaea43af0be957ef78ff6;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;-1972.92,-1766.595;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode;3;-5396.165,162.9868;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;91;-5337.679,451.6586;Inherit;False;Property;_DissolveMaskPanSpeed;Dissolve Mask Pan Speed;20;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;161;-1813.56,-1851.737;Inherit;False;Disto;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-5532.164,9.986579;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;90;-5328.679,378.6577;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;166;-5219.207,326.1077;Inherit;False;161;Disto;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-5215.094,251.1346;Inherit;False;111;CustomUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;6;-5233.165,18.98657;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-5658.522,241.0942;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-5081.679,375.6585;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-4981.956,21.20225;Inherit;False;5;5;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;8;-4801.274,-64.16534;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;106;-5210.266,-687.5607;Inherit;False;1951.449;483.7219;Gradient Shape;12;25;20;21;12;16;19;100;11;14;27;117;165;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;9;-4726.361,147.3238;Inherit;False;Property;_DissolveMaskChannel;Dissolve Mask Channel;10;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;12;-5160.266,-636.6624;Inherit;True;Property;_GradientShape;Gradient Shape;5;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;11;-4839.559,-424.7293;Inherit;False;Property;_GradientShapeRotation;Gradient Shape Rotation;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;10;-4457.153,-1.104136;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-4678.559,-569.7295;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;13;-4239.6,2.432282;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode;14;-4595.559,-418.7293;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-4373.788,-424.9778;Inherit;False;111;CustomUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;165;-4347.927,-334.5757;Inherit;False;161;Disto;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;15;-4099.783,107.5861;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;19;-4407.559,-564.7294;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;104;-4713.032,689.6882;Inherit;False;1840.216;539.6607;Main Texture;14;36;38;37;28;31;34;29;30;95;93;96;94;45;119;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-4055.097,203.4165;Inherit;False;Property;_DissolveMaskInvert;Dissolve Mask Invert;14;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;18;-3937.396,106.1128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;100;-4190.427,-563.5316;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-4554.742,948.1702;Inherit;False;Property;_TextureRotation;Texture Rotation;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;28;-4663.032,739.6882;Inherit;True;Property;_Texture;Texture;0;0;Create;True;0;0;0;False;0;False;None;249b5f66597eaea43af0be957ef78ff6;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.LerpOp;22;-3733.413,5.874167;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;21;-3970.491,-415.8389;Inherit;False;Property;_GradientShapeChannel;Gradient Shape Channel;6;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;20;-4017.967,-637.5607;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-4401.742,818.1707;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;93;-4122.628,1019.872;Inherit;False;Property;_TexturePanSpeed;Texture Pan Speed;17;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RadiansOpNode;30;-4310.743,954.1702;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;95;-4110.41,944.062;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;25;-3628.454,-467.5418;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-3466.341,386.0851;Inherit;False;Property;_Dissolve;Dissolve;32;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-3891.408,954.063;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;23;-3523.992,90.94785;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;167;-3872.735,1168.681;Inherit;False;161;Disto;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;34;-4139.742,824.1708;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-3545.639,196.2182;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;119;-3883.605,1085.794;Inherit;False;111;CustomUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;27;-3423.817,-469.0079;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-3282.554,86.90255;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;107;-3369.499,-1186.259;Inherit;False;1654.745;429.7096;Color Texture;11;42;54;44;48;41;47;98;58;118;135;162;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;94;-3667.626,825.8732;Inherit;False;4;4;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;42;-3319.499,-1136.259;Inherit;True;Property;_ColorTexture;Color Texture;3;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;108;-3083.642,-749.4732;Inherit;False;1447.081;551.8389;Gradient Map;10;57;61;51;52;43;33;35;39;40;46;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-3202.626,-926.1298;Inherit;False;Property;_ColorRotation;Color Rotation;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-3519.3,752.6392;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;37;-3417.081,979.5288;Inherit;False;Property;_TextureChannel;Texture Channel;1;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-3226.523,-468.456;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-3037.626,-1058.129;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RadiansOpNode;47;-2958.626,-920.1301;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;33;-3033.642,-464.3626;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;38;-3200.186,803.2869;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;109;-2691.135,56.00194;Inherit;False;1086.786;483.4392;Adjustments;9;59;66;65;62;56;49;53;68;69;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;45;-3037.81,804.4418;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;35;-2846.187,-505.6342;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;48;-2753.626,-1055.129;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;162;-2732.463,-839.9899;Inherit;False;161;Disto;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-2726.546,-922.5546;Inherit;False;111;CustomUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2594.143,193.9429;Inherit;False;Property;_CorePower;Core Power;22;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-2873.009,104.5154;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;-2500.51,-1054.167;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2789.187,-400.6343;Inherit;False;Property;_InvertGradient;Invert Gradient;21;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;39;-2692.187,-504.6342;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;56;-2442.052,106.002;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2641.135,423.4412;Inherit;False;Property;_GlowIntensity;Glow Intensity;26;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;-2266.235,-1124.69;Inherit;True;Property;_TextureSample4;Texture Sample 4;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;43;-2511.188,-484.6341;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-2608.188,-313.6343;Inherit;False;Property;_GradientMapDisplacement;Gradient Map Displacement;16;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2333.968,206.5723;Inherit;False;Property;_CoreIntensity;Core Intensity;23;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-2444.414,333.2482;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2149.864,112.4105;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;55;-1616.964,-375.7467;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;135;-1971.506,-895.2654;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;58;-1937.755,-1125.614;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;51;-2449.447,-699.4732;Inherit;True;Property;_GradientMap;Gradient Map;15;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-2324.188,-481.6342;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;136;-1676.527,-954.5192;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;57;-2163.677,-514.5545;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;127;-1715.58,-164.1978;Inherit;False;Constant;_Value1;Value1;28;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-1946.929,319.2549;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;60;-1424.456,-611.82;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;69;-1769.349,316.9807;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;61;-1859.561,-515.1655;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;126;-1539.58,-169.1978;Inherit;False;Property;_MeshVertexColor;MeshVertexColor;31;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;137;-1436.527,-923.5192;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-1258.878,-129.508;Inherit;False;Property;_AlphaBoldness;Alpha Boldness;28;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-1235.613,-274.6995;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;64;-1294.719,-480.5314;Inherit;False;Property;_CoreColor;Core Color;25;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-1250.177,-867.2894;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;66;-1771.097,115.7909;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;67;-1108.567,-765.1617;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-1035.519,16.74426;Inherit;False;Property;_ValueStepAdd;ValueStepAdd;35;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1019.321,-203.2115;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;89;-1078.001,381.2035;Inherit;False;941;692.0367;Push Particle toward camera direction (no more glow clipping in the ground) | 0=Unabled;8;123;124;84;82;87;81;80;85;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-1014.519,-70.25574;Inherit;False;Property;_ValueStep;ValueStep;34;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;78;-835.6622,-273.9366;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-992.0015,798.7557;Inherit;False;Property;_CameraDirPush;CameraDirPush;29;0;Create;True;0;0;0;False;0;False;0;-50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;123;-1004.027,899.6945;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;70;-997.174,-619.4721;Inherit;False;Property;_DifferentCoreColor;Different Core Color;24;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;71;-951.0202,-775.9909;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;133;-865.5189,-4.255737;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;81;-1028.001,628.7556;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-730.7768,809.2678;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;80;-952.7215,431.2033;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;74;-760.4335,-861.5389;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;129;-717.8678,-90.51944;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-569.9038,809.6765;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;131;-542.5189,-110.2557;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;77;-552.9362,-749.5464;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-621.1819,-502.711;Inherit;False;Property;_Brightness;Brightness;27;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;82;-724.0015,501.7557;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-386.1823,-598.7109;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;121;-3236.266,372.5574;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;170;-512,128;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-2989.266,369.5582;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;-128,0;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;120;-3245.266,445.5583;Inherit;False;Property;_Vector0;Vector 0;18;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-349.0014,485.7556;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;173;-768,128;Inherit;False;Property;_DepthFadeIntensity;Depth Fade Intensity;37;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;130;-382.8283,-280.4471;Inherit;False;Property;_Step;Step;33;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-105.5206,-649.3044;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;/_Vefects_/T/SH_VFX_Vefects_DissolveAdd;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;113;1;114;0
WireConnection;113;0;110;0
WireConnection;152;0;150;0
WireConnection;154;2;146;0
WireConnection;111;0;113;0
WireConnection;158;0;153;0
WireConnection;158;1;151;0
WireConnection;156;2;146;0
WireConnection;155;0;154;0
WireConnection;155;2;152;0
WireConnection;159;0;155;0
WireConnection;159;1;156;4
WireConnection;159;2;157;0
WireConnection;159;3;158;0
WireConnection;148;0;146;0
WireConnection;148;1;159;0
WireConnection;149;0;148;0
WireConnection;149;1;147;0
WireConnection;160;0;149;0
WireConnection;163;0;160;0
WireConnection;163;1;164;0
WireConnection;3;0;1;0
WireConnection;161;0;163;0
WireConnection;4;2;2;0
WireConnection;6;0;4;0
WireConnection;6;2;3;0
WireConnection;5;2;2;0
WireConnection;92;0;90;0
WireConnection;92;1;91;0
WireConnection;7;0;6;0
WireConnection;7;1;5;4
WireConnection;7;2;116;0
WireConnection;7;3;92;0
WireConnection;7;4;166;0
WireConnection;8;0;2;0
WireConnection;8;1;7;0
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;16;2;12;0
WireConnection;13;0;10;0
WireConnection;14;0;11;0
WireConnection;15;0;13;0
WireConnection;19;0;16;0
WireConnection;19;2;14;0
WireConnection;18;0;15;0
WireConnection;100;0;19;0
WireConnection;100;1;117;0
WireConnection;100;2;165;0
WireConnection;22;0;13;0
WireConnection;22;1;18;0
WireConnection;22;2;17;0
WireConnection;20;0;12;0
WireConnection;20;1;100;0
WireConnection;31;2;28;0
WireConnection;30;0;29;0
WireConnection;25;0;20;0
WireConnection;25;1;21;0
WireConnection;96;0;95;0
WireConnection;96;1;93;0
WireConnection;23;0;22;0
WireConnection;34;0;31;0
WireConnection;34;2;30;0
WireConnection;27;0;25;0
WireConnection;26;0;23;0
WireConnection;26;1;24;3
WireConnection;26;2;128;0
WireConnection;94;0;34;0
WireConnection;94;1;96;0
WireConnection;94;2;119;0
WireConnection;94;3;167;0
WireConnection;36;0;28;0
WireConnection;36;1;94;0
WireConnection;32;0;27;0
WireConnection;32;1;26;0
WireConnection;44;2;42;0
WireConnection;47;0;41;0
WireConnection;33;0;32;0
WireConnection;38;0;36;0
WireConnection;38;1;37;0
WireConnection;45;0;38;0
WireConnection;35;0;33;0
WireConnection;48;0;44;0
WireConnection;48;2;47;0
WireConnection;50;0;26;0
WireConnection;50;1;45;0
WireConnection;98;0;48;0
WireConnection;98;1;118;0
WireConnection;98;2;162;0
WireConnection;39;0;35;0
WireConnection;56;0;50;0
WireConnection;56;1;49;0
WireConnection;54;0;42;0
WireConnection;54;1;98;0
WireConnection;43;0;39;0
WireConnection;43;1;33;0
WireConnection;43;2;40;0
WireConnection;65;0;50;0
WireConnection;65;1;62;0
WireConnection;59;0;56;0
WireConnection;59;1;53;0
WireConnection;58;0;54;0
WireConnection;52;0;43;0
WireConnection;52;1;46;0
WireConnection;136;0;58;0
WireConnection;136;1;135;1
WireConnection;57;0;51;0
WireConnection;57;1;52;0
WireConnection;68;0;59;0
WireConnection;68;1;65;0
WireConnection;60;0;55;0
WireConnection;69;0;68;0
WireConnection;61;0;57;0
WireConnection;126;1;127;0
WireConnection;126;0;60;0
WireConnection;137;0;136;0
WireConnection;73;0;55;4
WireConnection;73;1;69;0
WireConnection;73;2;126;0
WireConnection;63;0;137;0
WireConnection;63;1;61;0
WireConnection;63;2;60;0
WireConnection;66;0;59;0
WireConnection;67;0;63;0
WireConnection;67;1;64;0
WireConnection;67;2;66;0
WireConnection;76;0;73;0
WireConnection;76;1;72;0
WireConnection;78;0;76;0
WireConnection;71;0;67;0
WireConnection;133;0;132;0
WireConnection;133;1;134;0
WireConnection;124;0;85;0
WireConnection;124;1;123;2
WireConnection;74;0;63;0
WireConnection;74;1;71;0
WireConnection;74;2;70;0
WireConnection;129;0;78;0
WireConnection;129;1;132;0
WireConnection;129;2;133;0
WireConnection;87;0;124;0
WireConnection;131;0;129;0
WireConnection;77;0;74;0
WireConnection;82;0;80;0
WireConnection;82;1;81;0
WireConnection;79;0;77;0
WireConnection;79;1;75;0
WireConnection;170;0;173;0
WireConnection;122;0;121;0
WireConnection;122;1;120;0
WireConnection;171;0;79;0
WireConnection;171;1;170;0
WireConnection;84;0;82;0
WireConnection;84;1;87;0
WireConnection;130;1;78;0
WireConnection;130;0;131;0
WireConnection;0;2;79;0
WireConnection;0;9;130;0
WireConnection;0;11;84;0
ASEEND*/
//CHKSM=595D6A15CAC28BE4E7142320905A200AA777DC4A