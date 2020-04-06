CROSS_COMPILE = riscv32-unknown-linux-gnu-
CC = $(CROSS_COMPILE)gcc
CFLAGS = -Wall -Werror
LINK = $(CROSS_COMPILE)ld
AS = $(CROSS_COMPILE)as

SDK_LIB_DIR = $(KEYSTONE_SDK_DIR)/lib
SDK_APP_LIB = $(SDK_LIB_DIR)/libkeystone-eapp.a
SDK_INCLUDE_DIR = $(SDK_LIB_DIR)/app/include

LDFLAGS = -static -L$(SDK_LIB_DIR) -lkeystone-eapp
CFLAGS += -I$(SDK_INCLUDE_DIR)

APP_C_OBJS = $(patsubst %.c,%.o, $(APP_C_SRCS))
APP_A_OBJS = $(patsubst %.s,%.o, $(APP_A_SRCS))
APP_LDS ?= ../app.lds

APP_BIN = $(patsubst %,%.eapp_riscv,$(APP))

all: $(APP_BIN)

$(APP_C_OBJS): %.o: %.c
	echo $(CC) 
	$(CC) $(CFLAGS) -c $<

$(APP_BIN): %.eapp_riscv : $(APP_C_OBJS) $(APP_A_OBJS) $(SDK_APP_LIB)
	echo $(LINK)
	$(LINK) $(LDFLAGS) -o $@ $^ -T $(APP_LDS)
	chmod -x $@

clean:
	rm -f *.o $(APP_BIN) $(EXTRA_CLEAN)
