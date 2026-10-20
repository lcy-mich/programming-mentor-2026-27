#include <stdio.h>

struct a { // NO = sign!!
    int value;
    bool flag;
}; // remember the semicolon!!!

typedef struct b {
    struct a *pointer; // you can have non-primitives as struct properties too

} node;

enum COLOURS { // NO = sign aswell!!
    RED, //NO need for quotes!!
    GREEN,
    BLUE = 4, //per enum, it's set with a value, by order starting from 0 and increments! or you can set it yourself!
    //ORANGE = "blue!"  YOU CANNOT SET THE VALUE OF THE ENUM TO ANYTHING OTHER THAN INT!!!
    YELLOW,
};


int main() {
    struct a /*to use structs as datatypes, remember its struct [name of struct]*/ hi = {20, true}; //you can straight up initialise the struct values by using this, but remember order matters!
    
    node thing; //and you can also use typedef!! and you can declare it first
    thing.pointer = &hi; //then instantiate the properties themselves

    struct b otherthing = {&hi}; // or use the original struct name, rather than the typedef, then initialise straight up

    printf("%d\n", (*otherthing.pointer).value); // you can get the value of the pointer, then access the struct
    printf("%d\n", otherthing.pointer->value); //or use -> syntax!, which is syntactic sugar for the same as the above!
    otherthing.pointer->value = 30; // remember -> is by reference, so you can set it like so
    otherthing.pointer->value++; // etc. etc.
    printf("%d aka %d\n", otherthing.pointer->value, hi.value);// and it'll update and print the new value properly!!

    enum COLOURS colour_of_the_sky = BLUE;

    typedef enum COLOURS PRIMARY_COLOURS; //you dont need to typedef directly on the declarations!!

    PRIMARY_COLOURS colour_of_grass = GREEN;

    printf("VALUE of RED: %d, VALUE of GREEN: %d, VALUE of BLUE: %d, VALUE of YELLOW: %d\n", RED, GREEN, BLUE, YELLOW); //notice yellow increments from value of blue!

    return 0;
}