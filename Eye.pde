
int PupilRegular = 0;
int PupilSpiral = 1;

class Pupil
{
    Pupil(Eye e)
    {
        m_eye = e;
        m_widthX = e.m_g / 4 + random(0.0, e.m_g / 3);
        m_widthY = e.m_g / 4 + random(0.0, e.m_g / 3);
        m_offsetX = random(-m_widthX / 2, m_widthX / 2);
        m_offsetY = random(-m_widthY / 2, m_widthY / 2);
        m_mode = PickMode();
        m_hasIris = (m_mode == PupilRegular) || (random(0.0, 1.0) < 0.5);
        if (m_mode == PupilSpiral)
        {
            m_spiralSpeed = random(0.01, 0.20);
        }
    }

    int PickMode()
    {
        if (random(0.0, 1.0) < 0.6)
        {
            return PupilRegular;
        }
        else
        {
            return PupilSpiral;
        }
    }

    void Draw()
    {
        if (m_hasIris)
        {                            
            fill(m_eye.Red() * 2.0, m_eye.Green(), m_eye.Blue(), m_eye.Alpha() / 2.0);
            stroke(m_eye.Red(), m_eye.Green() / 2, m_eye.Blue(), 153);
            strokeWeight(2.0);
            float mult = m_mode == PupilRegular ? 2.0 : 2.5;
            ellipse(m_eye.m_x + m_offsetX, m_eye.m_y + m_offsetY, m_widthX * mult, m_widthY * mult);
        }
        if (m_mode == PupilRegular)
        {
            fill(255);
            strokeWeight(5.0);
            stroke(0);
            ellipse(m_eye.m_x + m_offsetX, m_eye.m_y + m_offsetY, m_widthX / 2, m_widthY / 2);
        }
        else
        {            
            noFill();
            stroke(0);
            strokeWeight(0.5);
            int numDots = 200;
            for (int i = 1; i < numDots; ++ i)
            {
                line(m_eye.m_x + m_offsetX + m_widthX * ((float) (i - 1) / numDots) * sin((i - 1) * m_spiralSpeed),
                     m_eye.m_y + m_offsetY + m_widthY * ((float) (i - 1) / numDots) * cos((i - 1) * m_spiralSpeed),
                     m_eye.m_x + m_offsetX + m_widthX * ((float) i / numDots) * sin(i * m_spiralSpeed),
                     m_eye.m_y + m_offsetY + m_widthY * ((float) i / numDots) * cos(i * m_spiralSpeed));
            }
        }
    }

    Eye m_eye;
    float m_widthX;
    float m_widthY;
    float m_offsetX;
    float m_offsetY;

    int m_mode;
    boolean m_hasIris;

    float m_spiralSpeed;    
}

class EyeLid
{
    EyeLid(Eye e)
    {
        m_eye = e;
        m_lidHeight = random(0.0, e.m_g);
    }

    void Draw()
    {
        PGraphics fullEyeLid = createGraphics(2 * m_eye.m_g, 2 * m_eye.m_g);
        
        fullEyeLid.beginDraw();
        fullEyeLid.fill(m_eye.Red() / 1.25, m_eye.Green() / 1.25, m_eye.Blue());
        fullEyeLid.strokeWeight(1.0);
        fullEyeLid.stroke(0);
        fullEyeLid.ellipse(m_eye.m_g, m_eye.m_g, 2 * m_eye.m_g, 2 * m_eye.m_g);
        fullEyeLid.endDraw();
        
        PGraphics mask = createGraphics(2 * m_eye.m_g, 2 * m_eye.m_g);
        
        mask.beginDraw();
        mask.rect(0, 0, 2 * m_eye.m_g, m_lidHeight);
        mask.endDraw();
        
        IntersectShapes(fullEyeLid, mask);

        fullEyeLid.beginDraw();
        fullEyeLid.line(0, m_lidHeight, 2 * m_eye.m_g, m_lidHeight);
        fullEyeLid.endDraw();

        PGraphics mask2 = createGraphics(2 * m_eye.m_g, 2 * m_eye.m_g);
        mask2.beginDraw();
        mask2.ellipse(m_eye.m_g, m_eye.m_g, 2 * m_eye.m_g, 2 * m_eye.m_g);
        mask2.endDraw();

        IntersectShapes(fullEyeLid, mask2);
        
        image(fullEyeLid, m_eye.m_x - m_eye.m_g, m_eye.m_y - m_eye.m_g);
    }

    Eye m_eye;
    float m_lidHeight;
}

class Eye
{
    Eye(int xIn, int yIn, int gIn, color colorIn)
    {
        m_x = xIn;
        m_y = yIn;
        m_g = gIn;
        m_color = colorIn;
        m_pupil = new Pupil(this);
        if (random(0.0, 1.0) < 0.75)
        {
            m_eyeLid = new EyeLid(this);
        }

    }

    void Draw()
    {
        fill(255);
        stroke(0);
        strokeWeight(2.0);
        ellipse(m_x, m_y, m_g * 2, m_g * 2);
        m_pupil.Draw();
        if (m_eyeLid != null)
        {
            m_eyeLid.Draw();
        }
    }

    boolean Contains(int x, int y)
    {
        return (x - m_x) * (x - m_x) + (y - m_y) * (y - m_y) < m_g * m_g;
    }

    boolean WithinDistance(int x, int y, int dist)
    {
        return (x - m_x) * (x - m_x) + (y - m_y) * (y - m_y) < 2 * m_g * dist + m_g * m_g + dist * dist;
    }

    int Red() { return (int)red(m_color); }
    int Green() { return (int)green(m_color); }
    int Blue() { return (int)blue(m_color); }
    int Alpha() { return (int)alpha(m_color); }
    
    int m_x;
    int m_y;
    int m_g;
    color m_color;

    Pupil m_pupil;
    EyeLid m_eyeLid;
}
