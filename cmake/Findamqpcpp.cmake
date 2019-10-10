#Find the amqpcpp C++ library

INCLUDE(LibFindMacros)

# Find the include directories
FIND_PATH(amqpcpp_INCLUDE_DIR
        NAMES AMQPcpp.h amqpcpp.h
    HINTS ${amqpcpp_DIR}/include $ENV{HOME}/local/usr/local/include
	)

FIND_LIBRARY(amqpcpp_LIBRARY
	NAMES amqpcpp
    HINTS ${amqpcpp_DIR}/lib $ENV{HOME}/local/usr/local/lib
	)

SET(amqpcpp_PROCESS_INCLUDES amqpcpp_INCLUDE_DIR)
SET(amqpcpp_PROCESS_LIBS amqpcpp_LIBRARY)

LIBFIND_PROCESS(amqpcpp)

