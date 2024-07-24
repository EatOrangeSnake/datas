#pragma once


typedef struct _UInt {
    unsigned char* data;
    __SIZE_TYPE__ size;
} UInt;


extern UInt __attribute__((fastcall)) uint_add(UInt a, UInt b);
extern UInt __attribute__((fastcall)) uint_add_fge(UInt a, UInt b);
