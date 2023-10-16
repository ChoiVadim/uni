#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#include <fcntl.h>

#include "kbhit.h"

int kbhit() {
    struct termios oldt, newt;
    int ch;
    int oldf;

    // Get the current terminal settings
    tcgetattr(STDIN_FILENO, &oldt);

    // Set the terminal to non-canonical mode (no line buffering)
    newt = oldt;
    newt.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &newt);

    // Set the file descriptor for stdin to non-blocking
    oldf = fcntl(STDIN_FILENO, F_GETFL, 0);
    fcntl(STDIN_FILENO, F_SETFL, oldf | O_NONBLOCK);

    // Check if there is any input available
    ch = getchar();

    // Restore the terminal settings
    tcsetattr(STDIN_FILENO, TCSANOW, &oldt);

    // Restore the file descriptor flags
    fcntl(STDIN_FILENO, F_SETFL, oldf);

    // Return 1 if input is available, 0 otherwise
    if (ch != EOF) {
        ungetc(ch, stdin);
        return 1;
    }

    return 0;
}
