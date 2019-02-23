class SuperTup
{
    SuperTup(float xIn, float yIn)
    {
        x = xIn;
        y = yIn;
    }
    float x;
    float y;
}

SuperTup SuperCalc(int m, float n1, float n2, float n3, float phi)
{
    float a = 1.0;
    float b = 1.0;
    
    float t1 = cos(m * phi / 4) / a;
    t1 = abs(t1);
    t1 = pow(t1, n2);
    
    float t2 = sin(m * phi / 4) / b;
    t2 = abs(t2);
    t2 = pow(t2, n3);
    
    float r = pow(t1 + t2, 1 / n1);
    if (abs(r) == 0)
    {
        return new SuperTup(0,0);
    }
    else
    {
        r = 1 / r;
        return new SuperTup(r * cos(phi), r * sin(phi));
    }
}

class SuperPath
{
    ArrayList<SuperTup> path;
    
    SuperPath(
        float x,
        float y,
        float w,
        float h,
        int m,
        float n1,
        float n2,
        float n3,
        int points,
        float percentage,
        float range)
    {
        path = new ArrayList<SuperTup>();
        for (int i = 0; i < points; ++i)
        {
            if (i > points * percentage)
            {
                continue;
            }
            float phi = i * range / points;
            SuperTup dxdy = SuperCalc(m, n1, n2, n3, phi);
            dxdy.x = (dxdy.x * w) + x;
            dxdy.y = (dxdy.y * h) + y;
            path.add(dxdy);
        }
    }

    void Draw(PGraphics image)
    {
        image.beginShape();
        for (int i = 0; i < path.size(); ++i)
        {
            image.vertex(path.get(i).x, path.get(i).y);
        }
        image.endShape(CLOSE);
    }
}
