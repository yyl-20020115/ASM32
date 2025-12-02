// ASM32.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//
#include <stdio.h>

extern int __stdcall ASM32_ENTRY(int argc, char* file_path);

int main(int argc, char* argv[])
{
	printf("Seattle Computer Products 8086 Assembler Version 2.44\n");
	printf("Copyright 1979-1983 by Seattle Computer Products, Inc.\n");

	return argc <= 1 ? -1 : ASM32_ENTRY(argc - 1, argv[1]);
}
