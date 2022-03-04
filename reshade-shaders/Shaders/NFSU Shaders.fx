#include "ReShade.fxh"
#include "SH_SMAA.fxh"
#include "LUT.fxh"
#include "Fog.fxh"
#include "LUTOP.fxh"

technique SMAA
{
	pass EdgeDetectionPass
	{
		VertexShader = SMAAEdgeDetectionWrapVS;
		PixelShader = SMAAEdgeDetectionWrapPS;
		RenderTarget = edgesTex;
		ClearRenderTargets = true;
		StencilEnable = true;
		StencilPass = REPLACE;
		StencilRef = 1;
	}
	pass BlendWeightCalculationPass
	{
		VertexShader = SMAABlendingWeightCalculationWrapVS;
		PixelShader = SMAABlendingWeightCalculationWrapPS;
		RenderTarget = blendTex;
		ClearRenderTargets = true;
		StencilEnable = true;
		StencilPass = KEEP;
		StencilFunc = EQUAL;
		StencilRef = 1;
	}
	pass NeighborhoodBlendingPass
	{
		VertexShader = SMAANeighborhoodBlendingWrapVS;
		PixelShader = SMAANeighborhoodBlendingWrapPS;
		StencilEnable = false;
		SRGBWriteEnable = true;
	}
}

technique ReduxGraphics
{

pass LUT
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_LUT_Apply;
	}

	pass Fog

	{
		VertexShader = PostProcessVS;
		PixelShader = Fog;
	}

	pass LutAdd
	{
	VertexShader = PostProcessVS;
		PixelShader = PS_LUT_Apply2;
	}

	
	
}