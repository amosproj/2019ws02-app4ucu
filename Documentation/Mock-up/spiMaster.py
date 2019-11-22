import time
import spidev
# Enable SPI
spi = spidev.SpiDev()
spi.open(0,0)

# Set SPI speed and mode
spi.max_speed_hz = 500000
spi.mode = 0


msg = [0x76]
print(msg)
spi.writebytes(msg)
time.sleep(1)
msg = spi.readbytes(1)
print(msg)