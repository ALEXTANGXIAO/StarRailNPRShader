Shader "Honkai Star Rail/Character/EyeShadow"
{
    Properties
    {
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlendAlpha("Src Blend (A)", Float) = 0 // 默认 Zero
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlendAlpha("Dst Blend (A)", Float) = 0 // 默认 Zero
        _Color("Color", Color) = (0.6770648, 0.7038123, 0.8018868, 0.7647059)
        _DitherAlpha("Dither Alpha", Range(0, 1)) = 1
    }

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue" = "Geometry+10"  // 必须在脸之后绘制
        }

        Pass
        {
            Name "EyeShadow"

            Tags
            {
                "LightMode" = "HSRForward2"
            }

            // 眼睛部分
            Stencil
            {
                Ref 1
                ReadMask 1   // 眼睛位
                Comp Equal
                Pass Keep
                Fail Keep
            }

            Cull Back
            ZWrite Off // 不写入深度，仅仅是附加在图像上面

            Blend DstColor Zero, [_SrcBlendAlpha] [_DstBlendAlpha]

            ColorMask RGBA 0
            ColorMask 0 1

            HLSLPROGRAM

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "CharacterCommon.hlsl"

            CBUFFER_START(UnityPerMaterial)
                float4 _Color;
                float _DitherAlpha;
            CBUFFER_END

            #pragma vertex vert
            #pragma fragment frag

            float4 vert(float3 positionOS : POSITION) : SV_POSITION
            {
                return TransformObjectToHClip(positionOS);
            }

            float4 frag(float4 positionHCS : SV_POSITION) : SV_Target0
            {
                DitherAlphaEffect(positionHCS, _DitherAlpha);
                return _Color;
            }

            ENDHLSL
        }

        // No Outline
        // No Shadow
        // No Depth
    }

    CustomEditor "StaloSRPShaderGUI"
    Fallback Off
}
