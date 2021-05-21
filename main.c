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
            return "0";
        }
    }

    if (len2 == 1)
    {
        if (num2[0] == '0')
        {
            return "0";
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
    int index_loop;
    int carry;
    int dig1;
    int dig2;
    int mul_result;
    int i;
    int j;
    
    for (i=len1-1; i>=0; i--)
    {
        carry = 0;
        index_loop = index;

        dig1 = num1[i] - '0';

        for (j=len2-1; j>=0; j--)
        {
            dig2 = num2[j] - '0';

            mul_result = dig1*dig2;
            mul_result += result_string[index_loop];
            mul_result += carry;
            mul_result -= '0';

            carry = mul_result/10;

            result_string[index_loop] = mul_result % 10;
            result_string[index_loop] += '0';

            index_loop--;
        }
        result_string[index_loop] += carry;

        index--;
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


        strcpy(result_string, smul(result_string, num1, num2));
        puts(result_string);
    }

    return 0;
}

