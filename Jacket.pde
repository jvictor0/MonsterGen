
final int JacketSpikes = 0;
final int JacketBubbles = 1;
final int JacketHair = 2;
final int NumJackets = 3;

int DefaultJacket = -1;

String JacketTypeName(int jt)
{
    switch(jt)
    {
        case JacketSpikes: return "Spikes";
        case JacketBubbles: return "Bubbles";
        case JacketHair: return "Hair";
        default: return "None";
    }
}

void ToggleDefaultJacket()
{
    DefaultJacket += 1;
    if (DefaultJacket == NumJackets)
    {
         DefaultJacket = -1;
    }
    System.out.println("New jacket default is " + JacketTypeName(DefaultJacket));
}


class JacketPeice
{
    JacketPeice(float[] pts, int type, color strokeColor, color fillColor)
    {
        m_pts = pts;
        m_type = type;
        m_strokeColor = strokeColor;
        m_fillColor = fillColor;
    }

    void Draw(PGraphics image)
    {
        image.strokeWeight(1.0);
        if (m_type == JacketHair)
        {
            image.noFill();                        
        }
        else
        {
            image.fill(red(m_fillColor), green(m_fillColor), blue(m_fillColor), alpha(m_fillColor));
        }
        image.stroke(red(m_strokeColor), green(m_strokeColor), blue(m_strokeColor), alpha(m_strokeColor));      
        image.beginShape();
        image.vertex(m_pts[0], m_pts[1]);
        image.bezierVertex(m_pts[2], m_pts[3], m_pts[4], m_pts[5], m_pts[6], m_pts[7]);
        if (m_type == JacketHair)
        {
            image.endShape();
        }
        else
        {
            image.endShape(CLOSE);
        }
    }
    
    float[] m_pts;
    int m_type;
    color m_strokeColor;
    color m_fillColor;
}

class Jacket
{    
    Jacket(Head head)
    {
        m_head = head;
        m_strokeColor = color((head.Red() + head.Green()) * 0.8, (head.Green() + head.Blue()) * 0.8, (head.Blue() + head.Red()) * 0.8, 128);
        m_fillColor = color((head.Red() + head.Green()) * 0.5, (head.Green() + head.Blue()) * 0.5, (head.Blue() + head.Red()) * 0.5, 204);
        m_jacketPeices = new ArrayList<JacketPeice>();
        PickJacketType();
        GenJacketPeices();
    }

    void Draw()
    {
        PGraphics img = createGraphics(height, width);
        img.beginDraw();
        for (JacketPeice jp : m_jacketPeices)
        {
            jp.Draw(img);
        }
        img.endDraw();
        if (m_type != JacketSpikes)
        {
            IntersectShapes(img, m_head.m_interiorImage);
        }
        image(img, 0, 0);
    }

    void PickJacketType()
    {
        if (DefaultJacket == -1)
        {
            int[] jts = {JacketSpikes, JacketBubbles, JacketHair};
            m_type = jts[floor(random(0.0, 3.0))];
        }
        else
        {
            m_type = DefaultJacket;
        }
    }
    
    void GenJacketPeices()
    {
        float dx = 5 + random(m_head.m_width / 6);
        float dy = 5 + random(m_head.m_height / 6);
        for (float xtt = m_head.m_xPos - m_head.m_width; xtt < m_head.m_xPos + m_head.m_width; xtt += dx)
        {
            for (float ytt = m_head.m_yPos - m_head.m_height; ytt < m_head.m_yPos + m_head.m_height; ytt += dy)
            {
                float xt = m_type == JacketHair ? xtt : (xtt + random(-dx / 2, dx / 2));
                float yt = m_type == JacketHair ? ytt : (ytt + random(-dy / 2, dy / 2));                
                if (m_head.MainShapeContains((int) (xt - dx), (int) yt))
                {
                    float k = random(0.0, m_head.m_width / 4);
                    if (random(0.0, 1.0) > 0.5)
                    {
                        k = -k;                        
                    }
                    float[] p = null;
                    if (m_type == JacketSpikes)
                    {
                        float xtc = xt - m_head.m_xPos;
                        float ytc = yt - m_head.m_yPos;
                        float[] pts = {xt - dx, yt, xt, yt, xt, yt, xt + random(xtc), yt + random(ytc)};
                        p = pts;
                    }
                    else if (m_type == JacketBubbles)
                    {
                        float[] pts = {xt - dx, yt, xt + random(0.0, 5.0), yt, xt - (dx / 2), yt + k, xt - dx, yt};
                        p = pts;
                    }
                    else if (m_type == JacketHair)
                    {
                        float[] pts = {xt - dx, yt, xt - dx, yt, xt, yt + k, xt, yt};
                        p = pts;
                    }                    
                    else
                    {
                        assert(false);
                    }
                    m_jacketPeices.add(new JacketPeice(p, m_type, m_strokeColor, m_fillColor));
                }
            }
        }
    }
    
    Head m_head;
    color m_strokeColor;
    color m_fillColor;
    int m_type;
    ArrayList<JacketPeice> m_jacketPeices;
}

    
