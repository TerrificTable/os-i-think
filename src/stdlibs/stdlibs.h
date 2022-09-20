int strlen(const char* string) {
    int len = 0;
    char c = string[len];
    while (c != '\0') {
        len++;
        c = string[len];
    }
    return len;
}
