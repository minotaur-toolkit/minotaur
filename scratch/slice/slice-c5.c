#include <stdio.h>
#include <stdlib.h>
void print_array(int parray[], int size)
  {
   int i;      
   for( i=0; i<size-1; i++)  
    {  
        printf("%d, ", parray[i]);  
    } 
   printf("%d ", parray[i]);  
   printf("\n");   
  }
int main(void){
    int new_arr_size = 2;
    int arr_size;
    int nums1[] = { 1, 5, 7, 9, 11, 13};
    arr_size = sizeof(nums1)/sizeof(nums1[0]);
    printf("Elements in original array are: ");  
    print_array(nums1, arr_size);  
    int result[] = { nums1[arr_size / 2 - 1], nums1[arr_size / 2] };
    printf("New array: ");  
    print_array(result, new_arr_size);        
 } 
