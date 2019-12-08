#ifndef _FiFo_spi_h_
#define _FiFo_spi_h_

#include "types.h"




// Read how many Frames are in Buffer
uint16_t  spi_FiFoGetCountRx(void);
uint16_t  spi_FiFoGetCountTx(void);

// Add one Frame to Buffer. Return true if ok, false if Buffer Full
uint8_t spi_FiFoAddTx(uint32_t spiData_u32);

// Read Frame from Buffer. Return true if Frame read
uint8_t spi_FiFoGetRx(uint32_t *spiData_u32);


// Delete all Data in FiFo
void spi_FiFoClearRx(void);
void spi_FiFoClearTx(void);


#endif
