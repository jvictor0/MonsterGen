
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
        if (m_type == JacketHair)
        {
            image.strokeWeight(4.0);
            image.noFill();
            image.stroke(red(m_fillColor), green(m_fillColor), blue(m_fillColor), alpha(m_fillColor));      

        }
        else
        {
            image.strokeWeight(1.0);
            image.fill(red(m_fillColor), green(m_fillColor), blue(m_fillColor), alpha(m_fillColor));
            image.stroke(red(m_strokeColor), green(m_strokeColor), blue(m_strokeColor), alpha(m_strokeColor));      
        }
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
        PickJacketType();
        if (m_type == JacketHair)
        {
            m_fillColor = color((head.Red() + head.Green()) * 0.3, (head.Green() + head.Blue()) * 0.3, (head.Blue() + head.Red()) * 0.3);
        }
        else
        {               
            m_strokeColor = color((head.Red() + head.Green()) * 0.8, (head.Green() + head.Blue()) * 0.8, (head.Blue() + head.Red()) * 0.8, 128);
            m_fillColor = color((head.Red() + head.Green()) * 0.5, (head.Green() + head.Blue()) * 0.5, (head.Blue() + head.Red()) * 0.5, 204);
        }
        m_jacketPeices = new ArrayList<JacketPeice>();
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

    float GetDensity(float y, float dedensify, float maxHeight)
    {
        if (y < m_head.m_yPos)
        {
            return 1.0;
        }
        else
        {
            float h = min(1.0, (y - m_head.m_yPos) / (maxHeight - m_head.m_yPos));
            return 1.0 + (dedensify - 1.0) * h;
        }
    }
    
    void GenJacketPeices()
    {
        float dx = 5 + random(m_head.m_width / 20, m_head.m_width / 6);
        float dy = 5 + random(m_head.m_height / 20, m_head.m_height / 6);
        float dedensify = m_type == JacketSpikes ? random(1.0, 10.0) : 1.0;
        float maxHeight = m_type == JacketSpikes
                        ? random(m_head.m_yPos, m_head.m_yPos + m_head.m_height)
                        : height;
        System.out.println("maxHeight = " + maxHeight + ", density = " + dedensify);
        for (float ytt = 0; ytt < maxHeight; ytt += dy * GetDensity(ytt, dedensify, maxHeight))
        {
            boolean lastAdded = false;
            for (float xtt = 0; xtt < width; xtt += dx * GetDensity(ytt, dedensify, maxHeight))
            {
                float xt = xtt + random(-dx / 2, dx / 2);
                float yt = ytt + random(-dy / 2, dy / 2);                
                float k = random(0.0, m_head.m_width / 4);
                if (random(0.0, 1.0) > 0.5)
                {
                    k = -k;                        
                }
                float[] p = null;
                if (m_type == JacketSpikes)
                {
                    float xtc = (xt - m_head.m_xPos) / GetDensity(ytt, dedensify, maxHeight);
                    float ytc = (yt - m_head.m_yPos) / GetDensity(ytt, dedensify, maxHeight);
                    float[] pts = {xt - dx / 3, yt, xt, yt, xt + dx / 3, yt, xt + random(xtc / 3, xtc / 2), yt + random(ytc / 3, ytc / 2)};
                    p = pts;
                }
                else if (m_type == JacketBubbles)
                {
                    float[] pts = {xt - dx, yt, xt + random(0.0, 5.0), yt, xt - (dx / 2), yt + k, xt - dx, yt};
                    p = pts;
                }
                else if (m_type == JacketHair)
                {
                    float startX = lastAdded ? m_jacketPeices.get(m_jacketPeices.size() - 1).m_pts[6] : xt - dx;
                    float startY = lastAdded ? m_jacketPeices.get(m_jacketPeices.size() - 1).m_pts[7] : yt;
                    float[] pts = {startX, startY, xt - dx, yt, xt, yt + k, xt, yt};
                    p = pts;
                }                    
                else
                {
                    assert(false);
                }
                JacketPeice jp = new JacketPeice(p, m_type, m_strokeColor, m_fillColor);
                if (IsAdmissable(jp))
                {
                    lastAdded = true;
                    m_jacketPeices.add(jp);
                }
                else
                {
                    lastAdded = false;
                }
            }
        }
    }

    boolean IsAdmissable(JacketPeice jp)
    {
        float xmin = jp.m_pts[0];
        float ymin = jp.m_pts[1];
        float xmax = jp.m_pts[0];
        float ymax = jp.m_pts[1];
        for (int i = 0; i < 4; ++i)
        {
            if (m_type == JacketSpikes)
            {
                // Spikes covering the mouth and lips is ugly imho
                //
                if (m_head.MouthContains((int) jp.m_pts[2 * i], (int) jp.m_pts[2 * i + 1]))
                {
                    return false;
                }
                if (i == 3)
                {
                    continue;
                }
                if (!m_head.InteriorContains((int) jp.m_pts[2 * i], (int) jp.m_pts[2 * i + 1]))
                {
                    return false;
                }
            }
            xmin = min(xmin, jp.m_pts[2 * i]);
            xmax = max(xmax, jp.m_pts[2 * i]);
            ymin = min(ymin, jp.m_pts[2 * i + 1]);
            ymax = max(ymax, jp.m_pts[2 * i + 1]);
        }

        int dist = (int) sqrt((xmax - xmin) * (xmax - xmin) + (ymax - ymin) * (ymax - ymin)) / 4;
        
        for (Eye e : m_head.m_eyes)
        {
            for (int i = 0; i < 4; ++i)
            {
                if (i == 3 && m_type == JacketSpikes)
                {
                    continue;
                }
                if (e.WithinDistance((int) jp.m_pts[2 * i], (int) jp.m_pts[2 * i + 1], dist))
                {
                    return false;
                }
            }
        }
        return true;
    }
    
    Head m_head;
    color m_strokeColor;
    color m_fillColor;
    int m_type;
    ArrayList<JacketPeice> m_jacketPeices;
}

    
