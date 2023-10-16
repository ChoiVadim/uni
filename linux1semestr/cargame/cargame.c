#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include "kbhit.h"

int width, height;
int x, y, carY, carX, car2Y, car2X;
int score, gameover, flag;
int lives, difficulty, speed;
clock_t t; double time_taken;

void setup(void);
void draw(void);
void input(void);
void logic(void);

int main() 
{
    setup();

    while (!gameover)
    {
        draw();
        input();
        logic();
    }

    system("clear");
    printf("\nNice try!\nTime: %.2f second\n\n", time_taken);
    
    return 0;
}

void setup()
{
    lives = 3, score = 0;
    flag = 0, gameover = 0;
    width = 6;
    height = 20;
    speed = 70000;

    x = width / 2, y = height / 2;

label1:
    carX = rand() % width;
    if (carX == 0) goto label1;
    carY = 0;
    
label2:
    car2X = rand() % width;
    if (car2X == 0) goto label2;
    car2Y = rand() % 2;
}

void draw()
{
    system("clear");

    for (int i = 0; i <= height; i++)
    {
        for (int j = 0; j <= width; j++)
        {
            if (j == 0 || j == width)
            {
                printf("\xF0\x9F\x9A\xA7");
            }
            else
            {
                if (i == y && j == x) printf("🚘");
                else if (j == carX && i == carY) printf("🚘");
                else if (j == car2X && i == car2Y) printf("🚘");
                else if (j == width / 2 && i % 2 == 0) printf(" |");
                else printf("  ");
            }
        }
        printf("\n");
    }
    //printf("\nLives: %d left\n", lives);
    printf("\nMove: A,D,W,S\nExit: X\n");
    printf("Time: %.2fs", time_taken);
}

void logic(void)
{
    t = clock();
    time_taken = ((double)t) / 10000;

    usleep(speed);
    carY++;
    car2Y++;

    if (x == width)
    {
        x--;
    }
    
    if (x == 0)
    {
        x++;
    }
    
    if (y == height)
    {
        y--;
    }
    
    if (y == 0)
    {
        x++;
    }
    

    if (carY > height) 
    {
label3:
        carX = rand() % width;
        if (carX == 0) goto label3;
        carY = 0;
    }
    
    if (car2Y > height && (int)time_taken % 2 == 0) 
    {
label4:
        car2X = rand() % width;
        if (car2X == 0) goto label4;
        car2Y = rand() % 2;
    }

    if ((y == carY && x == carX) || (y == car2Y && x == car2X))
    {
        gameover = 1;
    }
    


}

void input(void)
{
    if (kbhit())
    {
    	char c = getchar();
        switch (c)
        {
        case 'c': flag = 0; break;
        case 'a': x--; break;
        case 'd': x++; break;
        case 'w': y--; break;
        case 's': y++; break;
        case 'x': gameover = 1; break;
        }
    }
}


