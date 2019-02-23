class Head
{
    Head(int xIn, int yIn, int wIn, int hIn, color cIn, int ppIn)
    {
        m_xPos = xIn;
        m_yPos = yIn;
        m_width = wIn;
        m_height = hIn;
        m_color = cIn;
        m_eyes = new ArrayList<Eye>();

        BuildMainShape();
        BuildMouthShape();

        SetupMainImages();
        
        GenJacket();

        PickEyes();
    }
 
    void Eye(Eye e)
    {
        e.Draw();
    }

    void BuildMainShape()
    {
        int m = int(random(1,30));
        float n1 = -0.8 + random(-5.0, 5.0);
        if (random(0.0, 1.0) < 0.5)
        {
            n1 = - n1;
        }
        float n2 = 0.5 + random(5.0);
        float n3 = 0.5 + random(0.5, -1.5);
        m_mainShape = new SuperPath(m_xPos, m_yPos, m_width, m_height, m, n1, n2, n3, 1000, 1.0, 2 * PI);
    }

    void BuildMouthShape()
    {
        int arms = 4 + (int)random(0.0, 20);
        m_mouthShape = new SuperPath(m_xPos, m_yPos + m_height / 1.5, m_width * 0.35, m_height * 0.65, arms, 0.98, 3.0, 0.81 + random(-0.8,0.8), 1000, 1.0, 2 * PI);
    }

    void SetupMainImages()
    {
        m_mainImage = createGraphics(height, width);
        m_mainImage.beginDraw();
        m_mainImage.fill(Red(), Green(), Blue());
        m_mainImage.stroke(Red() / 2, Green() / 2, Blue() / 2);
        m_mainImage.strokeWeight(m_width / 20);
        m_mainShape.Draw(m_mainImage);
        m_mainImage.endDraw();

        PGraphics mainMask = createGraphics(height, width);
        mainMask.beginDraw();
        m_mainShape.Draw(mainMask);
        mainMask.endDraw();
        
        PGraphics mouthMask = createGraphics(height, width);
        mouthMask.beginDraw();
        m_mouthShape.Draw(mouthMask);
        mouthMask.endDraw();

        SubtractShapes(m_mainImage, mouthMask);        

        m_mouthImage = createGraphics(height, width);
        m_mouthImage.beginDraw();
        m_mouthImage.stroke((Red() + Green()) * 0.8, (Green() + Blue()) * 0.8, (Blue() + Red()) * 0.8, 128);
        m_mouthImage.strokeWeight(m_width / 40);
        m_mouthImage.noFill();
        m_mouthShape.Draw(m_mouthImage);
        m_mouthImage.endDraw();

        IntersectShapes(m_mouthImage, mainMask);

        m_mainShapeImage = mainMask;
        SubtractShapes(m_mainShapeImage, mouthMask);

        m_interiorImage = createGraphics(height, width);
        m_interiorImage.beginDraw();
        m_mainShape.Draw(m_interiorImage);
        m_interiorImage.endDraw();

        PGraphics outline = createGraphics(height, width);
        outline.beginDraw();
        outline.noFill();
        outline.stroke(0);
        outline.strokeWeight(m_width / 20);
        m_mainShape.Draw(outline);
        outline.endDraw();

        SubtractShapes(m_interiorImage, mouthMask);
        SubtractShapes(m_interiorImage, outline);
    }

    void DrawMainShapes()
    {
        image(m_mainImage, 0, 0);
        image(m_mouthImage, 0, 0);
    }

    boolean MainShapeContains(int x, int y)
    {
        return ShapeContains(m_mainShapeImage, x, y);
    }

    boolean InteriorContains(int x, int y)
    {
        return ShapeContains(m_interiorImage, x, y);
    }

    void PickEyes()
    {
        int numEyes = (int) exp(random(log(2), log(50)));
        for (int i = 0; i < numEyes; ++i)
        {
            int ex = (int)(m_xPos + random(-m_width, m_width));
            int ey = (int)(m_yPos + random(-m_height));
            if (InteriorContains(ex, ey))
            {
                int g = (int) (5 + random(0.0, m_width / 5.0));
                boolean canUse = true;
                for (int j = 0; j < m_eyes.size() && canUse; ++j)
                {
                    canUse = canUse && !m_eyes.get(j).WithinDistance(ex, ey, g);
                }
                if (canUse)
                {
                    Eye e = new Eye(ex, ey, g, m_color);
                    m_eyes.add(e);
                }
            }
        }
    }

    void GenJacket()
    {
        m_jacket = new Jacket(this);
    }

    void DrawEyes()
    {
        for (Eye e : m_eyes)
        {
            e.Draw();
        }
    }

    void Draw()
    {
        DrawMainShapes();
        m_jacket.Draw();
        DrawEyes();
    }

    int Red() { return (int)red(m_color); }
    int Green() { return (int)green(m_color); }
    int Blue() { return (int)blue(m_color); }
    int Alpha() { return (int)alpha(m_color); }

    int m_xPos;
    int m_yPos;
    int m_width;
    int m_height;
    color m_color;
    ArrayList<Eye> m_eyes;
    Jacket m_jacket;

    SuperPath m_mainShape;
    SuperPath m_mouthShape;

    PGraphics m_mainImage;
    PGraphics m_mouthImage;
    PGraphics m_mainShapeImage;
    PGraphics m_interiorImage;
}

void EyeballGrid()
{
    for (int i = 0; i < height; i += 128)
    {
        for (int j = 0; j < width; j += 128)
        {
            Head h = new Head(0, 0, 0, 0, color(random(0,255), random(0,255), random(0,255)), 0);
            h.Eye(new Eye(i + 64, j + 64, 64, h.m_color));
        }
    }
}

Head RandomMonsterHead()
{
    int s = 200 + (int) random(0.0, 50);
    return new Head(width / 2, height / 2, s, s, color(random(0,255), random(0,255), random(0,255)), 0);
}
