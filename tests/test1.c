// had it working to get a simple flattening list, but clearly not branch specific
//main() -> fun1() -> llvm.var.annotation() -> printf() -> llvm.var.annotation() -> printf() -> foo() -> printf() -> printf()

#include <stdio.h>
#include <stdlib.h>

__attribute__((annotate("screen_function_paths"))) 
void foo(int a) { 
	printf("%d", a);	
	return;
}
		
int fun1(){
	__attribute__((annotate("screen_paths_start"))) char a = 'a';
	printf("Starting character: %c", a);
	__attribute__((annotate("screen_paths_end"))) char b = 'b';
	printf("Ending character: %c", b);
	char c = a + b;
	return (int) c;
}
	
__attribute__((annotate("screen_function_paths"))) 
int main(int argc, char **argv)
{

	(void)argc;
	(void)argv;

	int a = 0x41414141;
	int *b = &a;
	printf("BranchInst approaching...\n");
	if ( argc != 1)
		a = fun1();
	else
		foo(a);

	printf("a = %u *b = %u\n", a, *b);
}