# Put your MCU Information Here #
SET(MCU_FAMILY "STM32G0xx")
SET(MCU_MODEL "STM32G070xx")
SET(MCU_PARTNO "STM32G070rbtx")
SET(MCU_CORTEX "m0plus")


#Provide the location of the linker script, This is the memory map of the microcrontroller#
SET(LINKER_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/STM32G070KBTX_FLASH.ld")
MESSAGE(${LINKER_SCRIPT})
# Add MCU Specific Complier flags 
SET("MCU_FLAGS" "-mcpu=cortex-${MCU_CORTEX} -D${MCU_MODEL}")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${MCU_FLAGS}")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${MCU_FLAGS}")


# Add Include Directories for Micro #
SET(HAL_DRIVER_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver")	# Sets the appropriate include directory based on the MCU Family
SET(CORE_DRIVER_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/Core")
SET(CMSIS_DRIVER_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/Drivers/CMSIS")	# Sets the appropriate include directory based on the MCU Family

MESSAGE("Setting HAL Directory to: ${HAL_DRIVER_DIRECTORY}")
MESSAGE("Setting CMSIS Directory to: ${CMSIS_DRIVER_DIRECTORY}")

INCLUDE_DIRECTORIES(
	${HAL_DRIVER_DIRECTORY}/Inc
	${HAL_DRIVER_DIRECTORY}/Inc/Legacy
	${CMSIS_DRIVER_DIRECTORY}/Include
	${CMSIS_DRIVER_DIRECTORY}/Device/ST/${MCU_FAMILY}/Include
	${CORE_DRIVER_DIRECTORY}/Inc
)

# Build HAL Libraries #
# Must include all HAL Libraries in the Src Directory here or they will not be compiled into the static library

SET(LIBS 
	cortex 
	dma 
	dma_ex 
	exti 
	flash 
	flash_ex 
	gpio 
	i2c 
	i2c_ex 
	pwr 
	pwr_ex 
	rcc 
	rcc_ex 
	tim 
	tim_ex
	#uart
	#uart_ex
	)


SET(LIBNAME ${MCU_PARTNO}lib)
ADD_LIBRARY(${LIBNAME} STATIC)

TARGET_SOURCES(${LIBNAME} PRIVATE "${HAL_DRIVER_DIRECTORY}/Src/${MCU_FAMILY}_ll_rcc.c")
TARGET_SOURCES(${LIBNAME} PRIVATE "${HAL_DRIVER_DIRECTORY}/Src/${MCU_FAMILY}_hal.c")


FOREACH(HAL_LIB  IN LISTS LIBS)
	#MESSAGE("Adding Library ${MCU_FAMILY}_hal_${HAL_LIB}")
	TARGET_SOURCES(${LIBNAME} PRIVATE "${HAL_DRIVER_DIRECTORY}/Src/${MCU_FAMILY}_hal_${HAL_LIB}.c")
endforeach()

# Build Startup Assembly File
TARGET_SOURCES(${LIBNAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/startup/startup_${MCU_MODEL}.s")

# Make Static Library from Object Files





