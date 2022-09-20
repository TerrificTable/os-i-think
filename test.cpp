// testing stuff

#include <cstring>
#include <cstdio>

int getStrLen(char* string) {
    int len = 0;

    char c = string[len];
    while (c != '\0') {
        len++;
        c = string[len];
    }

    return len;
}


int main() {
    char* string    = "YYO SCHULE IST MÜLL";
    size_t length   = strlen(string);
    int length_1    = getStrLen(string);


    printf("%s\n", string);
    printf("%d\n", length);
    
    char* res = "same";
    if (length != length_1) res = "not the same";
    printf("%s\n", res);
}
