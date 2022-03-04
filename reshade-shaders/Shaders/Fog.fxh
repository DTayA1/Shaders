// PseudoVolumetricFog special for NFS Underground Redux.

#include "ReShade.fxh"

//============================================FOGCOLOR==========================================

static const float3 RGB_Lift = float3(0.860, 0.920, 1.0400);
static const float3 RGB_Gamma = float3(0.880, 1.040, 0.960);
static const float3 FogRGBBalance = float3(0.64706, 1.000, 0.88627);
static const float3 RGB_Gain = float3(1.220, 1.000, 1.060);

texture texColorBuffer : COLOR;
texture texDepthBuffer : DEPTH;

//============================================Disable for for loadscreens=========================

uniform bool disfog <
	ui_label = "Disable FOG for loadscreens and menu [BETA!]";
	ui_tooltip = 
	"Disable FOG for loadscreens and trackmenu [ON is recommended] \n"
	"Please off, if there are an graphics artifacts or fog disappears sometimes.\n";
> = true;

//============================================SAMPLERS============================================

sampler samplerDepth
{
	Texture = texDepthBuffer;
};

sampler highycord
{
	Texture = texDepthBuffer;
};

sampler lowycord
{
	Texture = texDepthBuffer;
};

sampler leftxcord
{
	Texture = texDepthBuffer;
};

sampler rightxcord
{
	Texture = texDepthBuffer;
};

sampler centerxcord
{
	Texture = texDepthBuffer;
};

sampler centerycord0
{
	Texture = texDepthBuffer;
};

sampler centerycord025
{
	Texture = texDepthBuffer;
};

sampler centerycord050
{
	Texture = texDepthBuffer;
};

sampler centerycord075
{
	Texture = texDepthBuffer;
};

sampler centerycord1
{
	Texture = texDepthBuffer;
};

sampler samplerColor
{
	Texture = texColorBuffer;
};

//================================FOG Calculation===========================================

void Fog(float4 pos : SV_Position, float2 texcoord : TEXCOORD0, out float4 color : SV_Target)
{ 
	float4 fogcolor = float4(FogRGBBalance.r, FogRGBBalance.g, FogRGBBalance.b, 24);
	float depth = tex2D(samplerDepth, texcoord).r;

	float4 tuman;
	
float2 texcoordn1;
float2 texcoordn2;
float2 texcoordn3;
float2 texcoordn4;
float2 texcoordn5;
float2 texcoordn01;
float2 texcoordn02;
float2 texcoordn03;
float2 texcoordn04;
float2 texcoordn05;


float depthwohy = tex2D(samplerDepth, texcoordn1.xy=(0,0)).r;
float depthwoly = tex2D(samplerDepth, texcoordn2.xy=(0,1)).r;
float depthwolx = tex2D(samplerDepth, texcoordn3.xy=(1,0)).r;
float depthworx = tex2D(samplerDepth, texcoordn4.xy=(1,1)).r;
float depthwoc = tex2D(samplerDepth, texcoordn4.xy=(0.5,0.5)).r;
float depthwoc01 = tex2D(samplerDepth, texcoordn01.xy=(0.5,0.0)).r;
float depthwoc02 = tex2D(samplerDepth, texcoordn02.xy=(0.5,0.25)).r;
float depthwoc03 = tex2D(samplerDepth, texcoordn03.xy=(0.5,0.5)).r;
float depthwoc04 = tex2D(samplerDepth, texcoordn04.xy=(0.5,0.75)).r;
float depthwoc05 = tex2D(samplerDepth, texcoordn05.xy=(0.5,0.1)).r;


	 	depthwohy = 2 / (-99.0 * depthwohy + 101.0);
	 	depthwoly = 2 / (-99.0 * depthwoly + 101.0);
	 	depthwolx = 2 / (-99.0 * depthwolx + 101.0);
	 	depthworx = 2 / (-99.0 * depthworx + 101.0);
		depthwoc = 2 / (-99.0 * depthwoc + 101.0);
depthwoc01 = 2 / (-99.0 * depthwoc01 + 101.0);

depthwoc02 = 2 / (-99.0 * depthwoc02 + 101.0);

depthwoc03 = 2 / (-99.0 * depthwoc03 + 101.0);

depthwoc04 = 2 / (-99.0 * depthwoc04 + 101.0);

depthwoc05 = 2 / (-99.0 * depthwoc05 + 101.0);

float depthxycenter=(depthwoc01+depthwoc02+depthwoc03+depthwoc04+depthwoc05)/5;


float xxxx=0;
float xyyy=0;
float xxyy=0;
float xxxy=0;
float cccc=0;

if(depthwohy<1){
xxxx=0;}
else{xxxx=10;}

if(depthwoly<1){
xyyy=0;}
else{xyyy=10;}

if(depthwolx<1){
xxyy=0;}
else{xxyy=10;}


if(depthworx<1){
xxxy=0;}
else{xxxy=10;}

if(depthwoc<1){
cccc=0;}
else{cccc=10;}

		float depthresult = xxxx*xxxy*xxyy*xxxy*cccc;

float black_point_float = 5 / 255.0;
	float white_point_float = 255 == 0 ? (255.0 / 0.00025) : (255.0 / (255 - 0));
		float2 distance_xy = texcoord - (0.5,0.5);
		distance_xy *= float2((ReShade::PixelSize.y / ReShade::PixelSize.x), 6);
		distance_xy /= 4;
		float distance = dot(distance_xy, distance_xy);

if (!disfog){depthresult=0;}
color = tex2D(samplerColor, texcoord);

if (depthresult<1){

depth = pow(depth, (((48.0+10)/100)*4));
depth *= (1 + pow(distance, 2 * 0.5) * (-0.095)); //pow - multiply
	depth = ((0.24)*2.5) / (-99.0 * depth + 101.0);
	 	depth = depth * white_point_float - (black_point_float *  white_point_float);
		float alpha = depth;
		 color = (100/100*depth * fogcolor + ((0.00/100/4 + 1)- depth) * color);
float rescolorr=float(color.r);
float rescolorg=float(color.g);
float rescolorb=float(color.b);
float3 coloraftcor = float3(rescolorr,rescolorg,rescolorb);

	coloraftcor = coloraftcor * (1.5 - 0.5 * RGB_Lift) + 0.5 * RGB_Lift - 0.5;
	coloraftcor = saturate(coloraftcor); // Is not strictly necessary, but does not cost performance
	
	// -- Gain --
	coloraftcor *= RGB_Gain; 
	
	// -- Gamma --
	coloraftcor = pow(coloraftcor, 1.0 / RGB_Gamma);


float4 colorfcr=float4(coloraftcor.r,coloraftcor.g,coloraftcor.b,alpha);
float tuman = depth;
color = (100/100*colorfcr * tuman + ((0/100/4 + 1)- tuman) * color);

// ENABLE ONLY DEPTH!
// color=tuman;
	
	}

else
{color=color;
color = pow(color, 0.560);
	
	
}

}