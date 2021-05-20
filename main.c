#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "func.h"

char* multiply(char* result_string, char* num1, char* num2)
{
    int len1 = strlen(num1);
    int len2 = strlen(num2);
    int result_len = len1+len2;
    
    // fill string with '0'
    for (int i=0; i<result_len; i++)
    {
        result_string[i] = '0';
    }
    result_string[result_len] = '\0';
    
    // multiply strings
    int a=0;
    int index;
    int carry;
    int n1;
    int n2;
    int sum;
     
    for (int i=len1-1; i>=0; i--)
    {
        index = a;
        carry = 0;
        n1 = num1[i] - '0';
       
        for (int j=len2-1; j>=0; j--)
        {
            n2 = num2[j] - '0';

            sum = n1*n2;
            sum += result_string[index];
            sum += carry;
            sum -= '0';

            carry = sum/10;

            result_string[index] = sum % 10;
            result_string[index] += '0';

            index++;
        }
        result_string[index] += carry;

        a++;
        index++;
    }

    // remove '0' from sufix
    int n = result_len;
    while (n>=0)
    {
        n--;
        if (result_string[n] != '0')
        {
            result_string[n+1] = '\0';
            break;
        }
    }

    // revers digits
    int i = 0;
    n = strlen(result_string)-1;

    while(i<n)
    {
        char n_char = result_string[n];
        if (n_char != '0')
        {
            char ch = result_string[i];
            result_string[i] = n_char;
            result_string[n] = ch;
            i++;
        }
        n--;
    }

    return result_string;
}

int main(int argc, char *argv[])
{
    if (argc < 3)
	{
		printf("Not enough arguments.\n"
               "Run program as \"%s <some alphanumeric text>\"\n", argv[0]);
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

        //int result = smul(result_string, num1, num2);
        //printf("%i\n", result);
    }

    return 0;
}

