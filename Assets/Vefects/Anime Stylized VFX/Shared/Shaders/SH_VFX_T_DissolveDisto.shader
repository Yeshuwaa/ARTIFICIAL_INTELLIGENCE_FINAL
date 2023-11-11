// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "/_Vefects_/T/SH_VFX_Vefects_DissolveDisto"
{
	Properties
	{
		_Texture("Texture", 2D) = "white" {}
		_TextureChannel("Texture Channel", Vector) = (0,1,0,0)
		_TextureRotation("Texture Rotation", Float) = 0
		_DissolveMask("Dissolve Mask", 2D) = "white" {}
		_DissolveMaskChannel("Dissolve Mask Channel", Vector) = (0,1,0,0)
		_DissolveMaskRotation("Dissolve Mask Rotation", Float) = 0
		_DissolveMaskInvert("Dissolve Mask Invert", Range( 0 , 1)) = 0
		_CorePower("Core Power", Float) = 1
		_CoreIntensity("Core Intensity", Float) = 0
		_GlowIntensity("Glow Intensity", Float) = 1
		_StrDisto("StrDisto", Float) = 1
		_CameraDirPush("CameraDirPush", Float) = 0
		[Toggle(_DEBUG_ON)] _Debug("Debug", Float) = 0
		[Toggle(_CUSTOMPANSWITCH_ON)] _CustomPanSwitch("CustomPanSwitch", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.5
		#pragma shader_feature_local _DEBUG_ON
		#pragma shader_feature_local _CUSTOMPANSWITCH_ON
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Unlit alpha:fade keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
			float2 uv2_texcoord2;
		};

		uniform float _CameraDirPush;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform float _TextureRotation;
		uniform float4 _TextureChannel;
		uniform sampler2D _DissolveMask;
		uniform float4 _DissolveMask_ST;
		uniform float _DissolveMaskRotation;
		uniform float4 _DissolveMaskChannel;
		uniform float _DissolveMaskInvert;
		uniform float _GlowIntensity;
		uniform float _CorePower;
		uniform float _CoreIntensity;
		uniform float _StrDisto;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 temp_output_82_0 = ( ase_worldPos - _WorldSpaceCameraPos );
			v.vertex.xyz += ( temp_output_82_0 * ( _CameraDirPush * 0.01 ) );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 uvs_Texture = i.uv_texcoord;
			uvs_Texture.xy = i.uv_texcoord.xy * _Texture_ST.xy + _Texture_ST.zw;
			float cos34 = cos( radians( _TextureRotation ) );
			float sin34 = sin( radians( _TextureRotation ) );
			float2 rotator34 = mul( uvs_Texture.xy - float2( 0.5,0.5 ) , float2x2( cos34 , -sin34 , sin34 , cos34 )) + float2( 0.5,0.5 );
			float2 temp_cast_0 = (0.0).xx;
			#ifdef _CUSTOMPANSWITCH_ON
				float2 staticSwitch104 = i.uv2_texcoord2;
			#else
				float2 staticSwitch104 = temp_cast_0;
			#endif
			float2 CustomUV105 = staticSwitch104;
			float dotResult38 = dot( tex2D( _Texture, ( rotator34 + CustomUV105 ) ) , _TextureChannel );
			float4 uvs_DissolveMask = i.uv_texcoord;
			uvs_DissolveMask.xy = i.uv_texcoord.xy * _DissolveMask_ST.xy + _DissolveMask_ST.zw;
			float cos6 = cos( radians( _DissolveMaskRotation ) );
			float sin6 = sin( radians( _DissolveMaskRotation ) );
			float2 rotator6 = mul( uvs_DissolveMask.xy - float2( 0.5,0.5 ) , float2x2( cos6 , -sin6 , sin6 , cos6 )) + float2( 0.5,0.5 );
			float dotResult10 = dot( tex2D( _DissolveMask, ( rotator6 + uvs_DissolveMask.w + CustomUV105 ) ) , _DissolveMaskChannel );
			float temp_output_13_0 = saturate( dotResult10 );
			float lerpResult22 = lerp( temp_output_13_0 , saturate( ( 1.0 - temp_output_13_0 ) ) , _DissolveMaskInvert);
			float temp_output_50_0 = ( saturate( dotResult38 ) * ( saturate( lerpResult22 ) + i.uv_texcoord.z ) );
			float temp_output_76_0 = ( ( i.vertexColor.a * saturate( ( ( temp_output_50_0 * _GlowIntensity ) + ( pow( temp_output_50_0 , _CorePower ) * _CoreIntensity ) ) ) ) * ( _StrDisto * 0.1 ) );
			float4 screenColor94 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( (ase_grabScreenPosNorm).xy + temp_output_76_0 ));
			float4 temp_cast_3 = (( temp_output_76_0 * 200.0 )).xxxx;
			#ifdef _DEBUG_ON
				float4 staticSwitch99 = temp_cast_3;
			#else
				float4 staticSwitch99 = screenColor94;
			#endif
			o.Emission = staticSwitch99.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18921
-1920;363;1920;1019;4259.721;747.4846;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;101;-3874.759,-518.4668;Inherit;False;820.0869;299.5054;PanInCustomUV;4;105;104;103;102;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-3761.262,-468.4668;Inherit;False;Constant;_Value0;Value0;26;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;103;-3824.759,-377.9618;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1;-4997.04,976.5879;Inherit;False;Property;_DissolveMaskRotation;Dissolve Mask Rotation;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;-5358.52,761.0615;Inherit;True;Property;_DissolveMask;Dissolve Mask;3;0;Create;True;0;0;0;False;0;False;None;f5aba2dfe976c11499558e7dfdf6d7ef;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.StaticSwitch;104;-3556.262,-382.4668;Inherit;False;Property;_CustomPanSwitch;CustomPanSwitch;13;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-4903.06,845.9539;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RadiansOpNode;3;-4751.835,981.0502;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;-3278.674,-375.6068;Inherit;False;CustomUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-4576.774,1194.768;Inherit;False;105;CustomUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-4991.43,1074.131;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;6;-4626.029,851.1777;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-4303.617,856.2925;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;9;-4012.73,980.3699;Inherit;False;Property;_DissolveMaskChannel;Dissolve Mask Channel;4;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-4053.644,773.8809;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;28;-4469.45,243.8727;Inherit;True;Property;_Texture;Texture;0;0;Create;True;0;0;0;False;0;False;None;f5aba2dfe976c11499558e7dfdf6d7ef;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;29;-4182.793,493.8165;Inherit;False;Property;_TextureRotation;Texture Rotation;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;10;-3690.52,777.9421;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;13;-3511.766,778.0182;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-4058.887,354.017;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RadiansOpNode;30;-3938.797,499.8164;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;34;-3781.832,359.3982;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;-3717.351,498.4562;Inherit;False;105;CustomUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;15;-3375.949,879.1721;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;107;-3497.306,360.4952;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-3336.265,1026.003;Inherit;False;Property;_DissolveMaskInvert;Dissolve Mask Invert;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;18;-3221.564,881.6988;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;22;-3052.581,776.4601;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-3279.558,252.7006;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;37;-3186.467,466.081;Inherit;False;Property;_TextureChannel;Texture Channel;1;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;23;-2883.16,773.5339;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;38;-2913.57,255.7296;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-2980.807,934.804;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-2729.722,777.4886;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;45;-2744.143,255.2777;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2422.357,631.5543;Inherit;False;Property;_CorePower;Core Power;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-2541.086,481.7468;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2134.944,640.2133;Inherit;False;Property;_CoreIntensity;Core Intensity;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2433.447,288.6531;Inherit;False;Property;_GlowIntensity;Glow Intensity;9;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;56;-2244.865,483.2138;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-2232.029,325.1596;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-1963.34,483.5505;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-1750.364,323.9587;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-1559.702,420.6016;Inherit;False;Property;_StrDisto;StrDisto;10;0;Create;True;0;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;55;-1615.022,120.2741;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;69;-1609.808,323.3116;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-1348.063,417.7196;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-1390.337,297.9102;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;90;-1261.793,99.67755;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1180.045,294.398;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;89;-875.5031,569.6993;Inherit;False;891;430.5521;Push Particle toward camera direction (no more glow clipping in the ground) | 0=Unabled;7;80;81;82;83;84;85;87;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;92;-984.7935,99.67755;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;95;-984.7935,193.6776;Inherit;False;True;True;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-508.5034,805.2515;Inherit;False;Property;_CameraDirPush;CameraDirPush;11;0;Create;True;0;0;0;False;0;False;0;-40;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;93;-773.7935,129.6776;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;81;-825.5031,817.2515;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;80;-750.2234,619.6993;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScreenColorNode;94;-311.7935,125.6776;Inherit;False;Global;_GrabScreen0;Grab Screen 0;12;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-975.3101,293.6954;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;200;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;82;-521.5034,690.2515;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-303.4059,785.1721;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;99;-116.0459,256.6518;Inherit;False;Property;_Debug;Debug;12;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-146.5034,674.2515;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;83;-353.5034,683.2515;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;101,214;Float;False;True;-1;3;ASEMaterialInspector;0;0;Unlit;/_Vefects_/T/SH_VFX_Vefects_DissolveDisto;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;104;1;102;0
WireConnection;104;0;103;0
WireConnection;4;2;2;0
WireConnection;3;0;1;0
WireConnection;105;0;104;0
WireConnection;5;2;2;0
WireConnection;6;0;4;0
WireConnection;6;2;3;0
WireConnection;7;0;6;0
WireConnection;7;1;5;4
WireConnection;7;2;108;0
WireConnection;8;0;2;0
WireConnection;8;1;7;0
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;13;0;10;0
WireConnection;31;2;28;0
WireConnection;30;0;29;0
WireConnection;34;0;31;0
WireConnection;34;2;30;0
WireConnection;15;0;13;0
WireConnection;107;0;34;0
WireConnection;107;1;106;0
WireConnection;18;0;15;0
WireConnection;22;0;13;0
WireConnection;22;1;18;0
WireConnection;22;2;17;0
WireConnection;36;0;28;0
WireConnection;36;1;107;0
WireConnection;23;0;22;0
WireConnection;38;0;36;0
WireConnection;38;1;37;0
WireConnection;26;0;23;0
WireConnection;26;1;24;3
WireConnection;45;0;38;0
WireConnection;50;0;45;0
WireConnection;50;1;26;0
WireConnection;56;0;50;0
WireConnection;56;1;49;0
WireConnection;65;0;50;0
WireConnection;65;1;62;0
WireConnection;59;0;56;0
WireConnection;59;1;53;0
WireConnection;68;0;65;0
WireConnection;68;1;59;0
WireConnection;69;0;68;0
WireConnection;96;0;72;0
WireConnection;73;0;55;4
WireConnection;73;1;69;0
WireConnection;76;0;73;0
WireConnection;76;1;96;0
WireConnection;92;0;90;0
WireConnection;95;0;76;0
WireConnection;93;0;92;0
WireConnection;93;1;95;0
WireConnection;94;0;93;0
WireConnection;100;0;76;0
WireConnection;82;0;80;0
WireConnection;82;1;81;0
WireConnection;87;0;85;0
WireConnection;99;1;94;0
WireConnection;99;0;100;0
WireConnection;84;0;82;0
WireConnection;84;1;87;0
WireConnection;83;0;82;0
WireConnection;0;2;99;0
WireConnection;0;11;84;0
ASEEND*/
//CHKSM=19C94DB0C1E1241226FC3BB9120D8363B77498B8