unsigned function(unsigned *p) {
    unsigned sum = 0;
    unsigned multiply = 1;
    for (int i = 0 ; i < 1024 ; i ++) {
        sum += p[i];
        multiply *= p[i];
    }
    return sum + multiply;
}