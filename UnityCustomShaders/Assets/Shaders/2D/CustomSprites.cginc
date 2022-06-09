#ifndef CUSTOM_SPRITES_INCLUDED
#define CUSTOM_SPRITES_INCLUDED

#include "UnityCG.cginc"
#include "UnitySprites.cginc"

sampler2D _DissolveTex;
float _DissolveVal;

fixed4 SpriteDissolve(v2f IN) : SV_Target
{
    fixed4 c            = SampleSpriteTexture(IN.texcoord) * IN.color;
    fixed4 dissolve     = tex2D(_DissolveTex, IN.texcoord);
    fixed4 clear        = fixed4(0, 0, 0, 0);

    int isClear         = int(dissolve.r - (_DissolveVal) + 0.99);
	int isAtLeastLine   = int(dissolve.r - (_DissolveVal) + 0.99);

	fixed4 altCol = lerp(c, clear, isClear);

    c.rgb *= c.a;

    c.rgb   = lerp(c.rgb, altCol.rgb, isAtLeastLine);
    c.a     = lerp(1.0, 0.0, isClear) * c.a;

    return c;
}

#endif // UNITY_SPRITES_INCLUDED