void setup()
{
    size(1024, 1024);
    DrawRandomMonster();
}

Head g_head;

void DrawRandomMonster()
{
    background(0);
    g_head = RandomMonsterHead();
    g_head.Draw();
}

void keyPressed()
{
    switch (key)
    {
        case ' ': DrawRandomMonster(); break;
        case 'j':
        {
            ToggleDefaultJacket();
            g_head.GenJacket();
            background(0);
            g_head.Draw();
            break;
        }
        case 'q': System.exit(0);
            
        default: break;
    }

}

void draw()
{
    
}
