#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "func.h"


char* multiply(char* result_string, char* num1, char* num2)
{
    int len1 = strlen(num1);
    int len2 = strlen(num2);
    int result_len = len1+len2;

    char result[result_len];
    for (int i=0; i<result_len; i++)
    {
        result[i] = '0';
    }
    result[result_len] = '\0';
 
    int i_n1 = 0;
    int i_n2 = 0;
     
    for (int i=len1-1; i>=0; i--)
    {
        int carry = 0;
        int n1 = num1[i] - '0';
 
        i_n2 = 0;
       
        for (int j=len2-1; j>=0; j--)
        {
            int n2 = num2[j] - '0';
            int sum = n1*n2 + result[i_n1 + i_n2] - 48 + carry;
            carry = sum/10;
            result[i_n1 + i_n2] = sum % 10 + 48;
            i_n2++;
        }
 
        if (carry > 0)
            result[i_n1 + i_n2] += carry;
 
        i_n1++;
    }

    int i = result_len-1;
    while (i>=0)
    {
        if (result[i] != '0')
        {
            int j = 0;
            while (i>=0)
            {
                result_string[j] = result[i];
                i--;
                j++;
            }
            result_string[j] = '\0';
            break;
        }
        i--;
    }

    return result_string;
}

int main()
{
	char* num1 = "7628346928349234";
    char* num2 = "789236498234022029387402";
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


        //strcpy(result_string, smul(result_string, num1, num2));
        int result = smul(result_string, num1, num2);
        //puts(result_string);
        printf("%i", result);
    }

    return 0;
}

