#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "func.h"

char* multiply(char* result_string, char* num1, char* num2)
{
    int len1 = strlen(num1);
    int len2 = strlen(num2);

    if (len1 == 1)
    {
        if (num1[0] == '0')
        {
            return num1;
        }
    }

    if (len2 == 1)
    {
        if (num2[0] == '0')
        {
            return num2;
        }
    }
    
    int result_len = len1+len2;
    
    // fill string with '0'
    for (int i=0; i<result_len; i++)
    {
        result_string[i] = '0';
    }
    result_string[result_len] = '\0';

    int index = result_len-1;
    
    for (int i=len1-1; i>=0; i--)
    {
        int carry = 0;

        int dig1 = num1[i] - '0';

        for (int j=len2-1; j>=0; j--)
        {
            int dig2 = num2[j] - '0';

            int mul_result = dig1*dig2;
            mul_result += result_string[index];
            mul_result += carry;
            mul_result -= '0';

            carry = mul_result/10;

            result_string[index] = mul_result % 10;
            result_string[index] += '0';

            index--;
        }
        result_string[index] += carry;
        index += len2;
        index -= 1;
    }

    // removing zero from beginning
    if (result_string[0] == '0') result_string++;


    return result_string;
}

int main(int argc, char *argv[])
{
    
    if (argc < 3)
	{
		printf("Not enough arguments.\n"
               "Run program as \"%s <number, numer>\"\n", argv[0]);
		return -1;
	}
    if (argc > 3)
	{
		printf("Too much arguments.\n"
               "Run program as \"%s <number, numer>\"\n", argv[0]);
		return -1;
	}
	char* num1 = argv[1];
    char* num2 = argv[2];
    int num1_len = strlen(num1);
    int num2_len = strlen(num2);

    if (num1_len == 0 || num2_len == 0)
    {
        printf("No result");
    }
    else
    {
        int result_len = num1_len+num2_len;

        char result_string[result_len];

        strcpy(result_string, multiply(result_string, num1, num2));
        printf("C function:        ");
        puts(result_string);

        char *result_buf = malloc(strlen(argv[1]) + strlen(argv[2]));
        char *result = smul(result_buf, argv[1], argv[2]);
        printf("Assembly function: ");
        
        puts(result);
        free(result_buf);
    }
   
    return 0;
}