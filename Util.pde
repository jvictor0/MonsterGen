void IntersectShapes(PGraphics sourceImage, PGraphics maskImage)
{
    int[] maskArray = new int[sourceImage.pixels.length];
    for (int i = 0; i < sourceImage.pixels.length; ++i)
    {
        maskArray[i] = int(min(alpha(maskImage.pixels[i]), alpha(sourceImage.pixels[i])));
    }
    sourceImage.mask(maskArray);
}

void SubtractShapes(PGraphics sourceImage, PGraphics maskImage)
{
    int[] maskArray = new int[sourceImage.pixels.length];
    for (int i = 0; i < sourceImage.pixels.length; ++i)
    {
        maskArray[i] = int(max(0.0, alpha(sourceImage.pixels[i]) - alpha(maskImage.pixels[i])));
    }
    sourceImage.mask(maskArray);
}
