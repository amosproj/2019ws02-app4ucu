#ifndef __RTE_AMOS_APP4UCU_H__
#define __RTE_AMOS_APP4UCU_H__


#include "Rte.h"

#ifdef __cplusplus
extern "C" {
#endif


#define Rte_InitValue_toApp_test_u8 Rte_InitValue_AMOS_APP4UCU_toApp_test_u8
#define Rte_InitValue_toApp_test_i8 Rte_InitValue_AMOS_APP4UCU_toApp_test_i8
#define Rte_InitValue_toApp_test_u16 Rte_InitValue_AMOS_APP4UCU_toApp_test_u16
#define Rte_InitValue_toApp_test_i16 Rte_InitValue_AMOS_APP4UCU_toApp_test_i16
#define Rte_InitValue_toApp_test_u32 Rte_InitValue_AMOS_APP4UCU_toApp_test_u32
#define Rte_InitValue_toApp_test_i32 Rte_InitValue_AMOS_APP4UCU_toApp_test_i32
#define Rte_InitValue_toApp_test_r32 Rte_InitValue_AMOS_APP4UCU_toApp_test_r32
#define Rte_InitValue_toApp_test_b Rte_InitValue_AMOS_APP4UCU_toApp_test_b
#define Rte_InitValue_fromApp_test_u8 Rte_InitValue_AMOS_APP4UCU_fromApp_test_u8
#define Rte_InitValue_fromApp_test_i8 Rte_InitValue_AMOS_APP4UCU_fromApp_test_i8
#define Rte_InitValue_fromApp_test_u16 Rte_InitValue_AMOS_APP4UCU_fromApp_test_u16
#define Rte_InitValue_fromApp_test_i16 Rte_InitValue_AMOS_APP4UCU_fromApp_test_i16
#define Rte_InitValue_fromApp_test_u32 Rte_InitValue_AMOS_APP4UCU_fromApp_test_u32
#define Rte_InitValue_fromApp_test_i32 Rte_InitValue_AMOS_APP4UCU_fromApp_test_i32
#define Rte_InitValue_fromApp_test_r32 Rte_InitValue_AMOS_APP4UCU_fromApp_test_r32
#define Rte_InitValue_fromApp_test_b Rte_InitValue_AMOS_APP4UCU_fromApp_test_b

 
  


// receiver-port: toApp
#define Rte_Read_toApp_test_u8 Rte_Read_AMOS_APP4UCU_toApp_test_u8
#define Rte_Read_toApp_test_i8 Rte_Read_AMOS_APP4UCU_toApp_test_i8
#define Rte_Read_toApp_test_u16 Rte_Read_AMOS_APP4UCU_toApp_test_u16
#define Rte_Read_toApp_test_i16 Rte_Read_AMOS_APP4UCU_toApp_test_i16
#define Rte_Read_toApp_test_u32 Rte_Read_AMOS_APP4UCU_toApp_test_u32
#define Rte_Read_toApp_test_i32 Rte_Read_AMOS_APP4UCU_toApp_test_i32
#define Rte_Read_toApp_test_r32 Rte_Read_AMOS_APP4UCU_toApp_test_r32
#define Rte_Read_toApp_test_b Rte_Read_AMOS_APP4UCU_toApp_test_b


// sender-port: fromApp
#define Rte_Write_fromApp_test_u8 Rte_Write_AMOS_APP4UCU_fromApp_test_u8
#define Rte_Write_fromApp_test_i8 Rte_Write_AMOS_APP4UCU_fromApp_test_i8
#define Rte_Write_fromApp_test_u16 Rte_Write_AMOS_APP4UCU_fromApp_test_u16
#define Rte_Write_fromApp_test_i16 Rte_Write_AMOS_APP4UCU_fromApp_test_i16
#define Rte_Write_fromApp_test_u32 Rte_Write_AMOS_APP4UCU_fromApp_test_u32
#define Rte_Write_fromApp_test_i32 Rte_Write_AMOS_APP4UCU_fromApp_test_i32
#define Rte_Write_fromApp_test_r32 Rte_Write_AMOS_APP4UCU_fromApp_test_r32
#define Rte_Write_fromApp_test_b Rte_Write_AMOS_APP4UCU_fromApp_test_b



/* runnables */
void AMOS_APP4UCU_AMOS_APP4UCU_Init(void);
void AMOS_APP4UCU_AMOS_APP4UCU_Cyclic(void);
  


#ifdef __cplusplus
}
#endif
  

#endif
