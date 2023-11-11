// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "/_Vefects_/T/SH_VFX_Vefects_FresnBomb"
{
	Properties
	{
		_DissolveMask("Dissolve Mask", 2D) = "white" {}
		_DissolveMaskChannel("Dissolve Mask Channel", Vector) = (0,1,0,0)
		_DissolveMaskRotation("Dissolve Mask Rotation", Float) = 0
		_DissolveMaskInvert("Dissolve Mask Invert", Range( 0 , 1)) = 0
		_DissolveMaskPanSpeed("Dissolve Mask Pan Speed", Vector) = (0,0,0,0)
		_CorePower("Core Power", Float) = 1
		_CoreIntensity("Core Intensity", Float) = 0
		_DifferentCoreColor("Different Core Color", Float) = 0
		_GlowIntensity("Glow Intensity", Float) = 1
		_Brightness("Brightness", Float) = 1
		_AlphaBoldness("Alpha Boldness", Float) = 1
		_Bias2("Bias2", Float) = 0
		_Bias("Bias", Float) = 0
		_Scale("Scale", Float) = 0
		_Scale2("Scale2", Float) = 0
		_Pow2("Pow2", Float) = 0
		_Pow("Pow", Float) = 0
		_Dist("Dist", Float) = 0
		[HDR]_ColorExt("ColorExt", Color) = (1,0.9669811,0.9669811,0)
		[HDR]_Colorint("Colorint", Color) = (1,0.9669811,0.9669811,0)
		[Toggle(_ISFIRSTEXPLO_ON)] _IsFirstExplo("Is First Explo", Float) = 0
		_AddDiss("AddDiss", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _ISFIRSTEXPLO_ON
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float3 worldPos;
			float3 worldNormal;
			float4 uv_texcoord;
			float4 screenPos;
		};

		uniform float4 _Colorint;
		uniform float4 _ColorExt;
		uniform float _Bias2;
		uniform float _Scale2;
		uniform float _Pow2;
		uniform sampler2D _DissolveMask;
		uniform float4 _DissolveMask_ST;
		uniform float _DissolveMaskRotation;
		uniform float2 _DissolveMaskPanSpeed;
		uniform float4 _DissolveMaskChannel;
		uniform float _DissolveMaskInvert;
		uniform float _CorePower;
		uniform float _CoreIntensity;
		uniform float _DifferentCoreColor;
		uniform float _Brightness;
		uniform float _GlowIntensity;
		uniform float _AlphaBoldness;
		uniform float _Bias;
		uniform float _Scale;
		uniform float _Pow;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Dist;
		uniform float _AddDiss;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 temp_output_60_0 = (i.vertexColor).rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV153 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode153 = ( _Bias2 + _Scale2 * pow( 1.0 - fresnelNdotV153, _Pow2 ) );
			float temp_output_162_0 = saturate( fresnelNode153 );
			float4 lerpResult154 = lerp( _Colorint , _ColorExt , temp_output_162_0);
			float4 uvs_DissolveMask = i.uv_texcoord;
			uvs_DissolveMask.xy = i.uv_texcoord.xy * _DissolveMask_ST.xy + _DissolveMask_ST.zw;
			float cos6 = cos( radians( _DissolveMaskRotation ) );
			float sin6 = sin( radians( _DissolveMaskRotation ) );
			float2 rotator6 = mul( uvs_DissolveMask.xy - float2( 0.5,0.5 ) , float2x2( cos6 , -sin6 , sin6 , cos6 )) + float2( 0.5,0.5 );
			float dotResult10 = dot( tex2D( _DissolveMask, ( rotator6 + uvs_DissolveMask.w + ( _Time.y * _DissolveMaskPanSpeed ) ) ) , _DissolveMaskChannel );
			float temp_output_13_0 = saturate( dotResult10 );
			float lerpResult22 = lerp( temp_output_13_0 , saturate( ( 1.0 - temp_output_13_0 ) ) , _DissolveMaskInvert);
			float temp_output_26_0 = ( saturate( lerpResult22 ) + i.uv_texcoord.z );
			float temp_output_59_0 = ( pow( temp_output_26_0 , _CorePower ) * _CoreIntensity );
			float temp_output_66_0 = saturate( temp_output_59_0 );
			#ifdef _ISFIRSTEXPLO_ON
				float staticSwitch159 = 1.0;
			#else
				float staticSwitch159 = 0.0;
			#endif
			float myVarName174 = staticSwitch159;
			float lerpResult172 = lerp( temp_output_66_0 , 1.0 , myVarName174);
			float4 lerpResult67 = lerp( float4( temp_output_60_0 , 0.0 ) , lerpResult154 , lerpResult172);
			float4 lerpResult74 = lerp( float4( temp_output_60_0 , 0.0 ) , saturate( lerpResult67 ) , _DifferentCoreColor);
			o.Emission = ( saturate( lerpResult74 ) * _Brightness ).rgb;
			float fresnelNdotV125 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode125 = ( _Bias + _Scale * pow( 1.0 - fresnelNdotV125, _Pow ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth132 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth132 = abs( ( screenDepth132 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Dist ) );
			float lerpResult169 = lerp( ( i.vertexColor.a * saturate( step( ( saturate( ( temp_output_59_0 + ( temp_output_26_0 * _GlowIntensity ) ) ) * _AlphaBoldness ) , ( fresnelNode125 + saturate( ( ( 1.0 - distanceDepth132 ) * 1.0 ) ) ) ) ) ) , saturate( step( ( temp_output_66_0 + i.vertexColor.a + _AddDiss ) , temp_output_162_0 ) ) , myVarName174);
			o.Alpha = lerpResult169;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xyzw = customInputData.uv_texcoord;
				o.customPack1.xyzw = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.screenPos = IN.screenPos;
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
-1967;478;1920;1013;1261.447;518.1195;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;105;-5979.15,-114.1653;Inherit;False;2848.594;729.824;Dissolve Mask;21;13;15;18;26;23;22;17;10;9;8;7;6;4;1;3;2;5;90;92;91;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;-5929.15,-60.98477;Inherit;True;Property;_DissolveMask;Dissolve Mask;0;0;Create;True;0;0;0;False;0;False;None;8e9f6e86d964cef4db775abb71619b05;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;1;-5659.369,140.5245;Inherit;False;Property;_DissolveMaskRotation;Dissolve Mask Rotation;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-5532.164,9.986579;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;90;-5328.679,378.6577;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;91;-5337.679,451.6586;Inherit;False;Property;_DissolveMaskPanSpeed;Dissolve Mask Pan Speed;4;0;Create;True;0;0;0;False;0;False;0,0;0,0.75;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RadiansOpNode;3;-5396.165,162.9868;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-5081.679,375.6585;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-5658.522,241.0942;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;6;-5233.165,18.98657;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-4981.956,21.20225;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;9;-4726.361,147.3238;Inherit;False;Property;_DissolveMaskChannel;Dissolve Mask Channel;1;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-4801.274,-64.16534;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;10;-4457.153,-1.104136;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;13;-4239.6,2.432282;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;15;-4099.783,107.5861;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-4055.097,203.4165;Inherit;False;Property;_DissolveMaskInvert;Dissolve Mask Invert;3;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;18;-3937.396,106.1128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;22;-3733.413,5.874167;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;109;-2814.262,-35.06187;Inherit;False;1086.786;483.4392;Adjustments;9;59;66;65;62;56;49;53;68;69;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-3545.639,196.2182;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;23;-3523.992,90.94785;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2717.27,102.8792;Inherit;False;Property;_CorePower;Core Power;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-3282.554,86.90255;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;160;-2346.513,750.5286;Inherit;False;1444.035;690.5199;First Explo;11;154;155;157;150;151;152;153;158;162;167;168;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;171;-862.4411,1151.089;Inherit;False;Constant;_eee;eee;23;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;170;-847.742,1065.487;Inherit;False;Constant;_aaa;aaa;23;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-1176.892,328.2925;Inherit;False;Property;_Dist;Dist;17;0;Create;True;0;0;0;False;0;False;0;0.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;132;-934.3589,263.1768;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2457.095,115.5085;Inherit;False;Property;_CoreIntensity;Core Intensity;6;0;Create;True;0;0;0;False;0;False;0;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-2294.513,1218.048;Inherit;False;Property;_Scale2;Scale2;14;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2764.262,332.3773;Inherit;False;Property;_GlowIntensity;Glow Intensity;8;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;159;-666.5278,1047.313;Inherit;False;Property;_IsFirstExplo;Is First Explo;20;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;56;-2565.179,14.9382;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;152;-2269.512,1325.048;Inherit;False;Property;_Pow2;Pow2;15;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-2296.513,1146.047;Inherit;False;Property;_Bias2;Bias2;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;174;-416.1376,1044.556;Inherit;False;myVarName;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-2567.541,242.1843;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2272.991,21.3467;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;136;-685.33,325.772;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;153;-2083.011,1176.348;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;157;-2080.019,914.8172;Inherit;False;Property;_ColorExt;ColorExt;18;1;[HDR];Create;True;0;0;0;False;0;False;1,0.9669811,0.9669811,0;0.3066038,0.4456163,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;126;-856.7548,-74.93999;Inherit;False;Property;_Bias;Bias;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-854.7548,-2.940007;Inherit;False;Property;_Scale;Scale;13;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-829.7546,104.06;Inherit;False;Property;_Pow;Pow;16;0;Create;True;0;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-2070.058,228.1911;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;155;-1911.019,853.8172;Inherit;False;Property;_Colorint;Colorint;19;1;[HDR];Create;True;0;0;0;False;0;False;1,0.9669811,0.9669811,0;1,0.9669811,0.9669811,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;162;-1754.862,1318.282;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;55;-1683.964,-523.7467;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;176;-834.804,-314.1371;Inherit;False;174;myVarName;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;165;-1188.005,-456.1076;Inherit;False;Constant;_Float0;Float 0;23;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;66;-1894.226,24.72711;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-537.9156,370.9853;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;154;-1649.086,1056.593;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;60;-1373.456,-850.82;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-1279.837,-104.5243;Inherit;False;Property;_AlphaBoldness;Alpha Boldness;10;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;172;-714.007,-416.1385;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;125;-625.254,-76.63925;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;69;-1892.478,225.9169;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;135;-451.8841,228.9642;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;167;-1641.619,890.1807;Inherit;False;Property;_AddDiss;AddDiss;21;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;67;-1110.273,-760.0452;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1038.882,-198.0897;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;149;-292.7903,68.48779;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-997.174,-619.4721;Inherit;False;Property;_DifferentCoreColor;Different Core Color;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;168;-1472.618,803.0809;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;71;-951.0202,-775.9909;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;142;-255.4697,-201.7636;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;138;49.06779,-190.5737;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;158;-1137.478,800.5286;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;74;-760.4335,-861.5389;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-621.1819,-502.711;Inherit;False;Property;_Brightness;Brightness;9;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;175;41.06995,-32.36731;Inherit;False;174;myVarName;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;77;-552.9362,-749.5464;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;161;-40.90902,281.7481;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;144.6933,-321.2775;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-386.1823,-598.7109;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;169;251.7223,-177.6426;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;468.6231,-661.562;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;/_Vefects_/T/SH_VFX_Vefects_FresnBomb;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;2;2;0
WireConnection;3;0;1;0
WireConnection;92;0;90;0
WireConnection;92;1;91;0
WireConnection;5;2;2;0
WireConnection;6;0;4;0
WireConnection;6;2;3;0
WireConnection;7;0;6;0
WireConnection;7;1;5;4
WireConnection;7;2;92;0
WireConnection;8;0;2;0
WireConnection;8;1;7;0
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;13;0;10;0
WireConnection;15;0;13;0
WireConnection;18;0;15;0
WireConnection;22;0;13;0
WireConnection;22;1;18;0
WireConnection;22;2;17;0
WireConnection;23;0;22;0
WireConnection;26;0;23;0
WireConnection;26;1;24;3
WireConnection;132;0;134;0
WireConnection;159;1;170;0
WireConnection;159;0;171;0
WireConnection;56;0;26;0
WireConnection;56;1;49;0
WireConnection;174;0;159;0
WireConnection;65;0;26;0
WireConnection;65;1;62;0
WireConnection;59;0;56;0
WireConnection;59;1;53;0
WireConnection;136;0;132;0
WireConnection;153;1;151;0
WireConnection;153;2;150;0
WireConnection;153;3;152;0
WireConnection;68;0;59;0
WireConnection;68;1;65;0
WireConnection;162;0;153;0
WireConnection;66;0;59;0
WireConnection;148;0;136;0
WireConnection;154;0;155;0
WireConnection;154;1;157;0
WireConnection;154;2;162;0
WireConnection;60;0;55;0
WireConnection;172;0;66;0
WireConnection;172;1;165;0
WireConnection;172;2;176;0
WireConnection;125;1;126;0
WireConnection;125;2;129;0
WireConnection;125;3;130;0
WireConnection;69;0;68;0
WireConnection;135;0;148;0
WireConnection;67;0;60;0
WireConnection;67;1;154;0
WireConnection;67;2;172;0
WireConnection;76;0;69;0
WireConnection;76;1;72;0
WireConnection;149;0;125;0
WireConnection;149;1;135;0
WireConnection;168;0;66;0
WireConnection;168;1;55;4
WireConnection;168;2;167;0
WireConnection;71;0;67;0
WireConnection;142;0;76;0
WireConnection;142;1;149;0
WireConnection;138;0;142;0
WireConnection;158;0;168;0
WireConnection;158;1;162;0
WireConnection;74;0;60;0
WireConnection;74;1;71;0
WireConnection;74;2;70;0
WireConnection;77;0;74;0
WireConnection;161;0;158;0
WireConnection;73;0;55;4
WireConnection;73;1;138;0
WireConnection;79;0;77;0
WireConnection;79;1;75;0
WireConnection;169;0;73;0
WireConnection;169;1;161;0
WireConnection;169;2;175;0
WireConnection;0;2;79;0
WireConnection;0;9;169;0
ASEEND*/
//CHKSM=8F06EC20FF5806BCF8E45FFB6927F35FEBD28FD6