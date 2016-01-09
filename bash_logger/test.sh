#!/bin/bash

# Source the logger
source bash_logger.sh

# Source the logger configuration file
# If you want to use default configuration remove the following line
source bash_logger.conf

# test function
function testFunction()
{
		DEBUG "$i debug log"
		INFO "$i info log"
		WARN "$i warn log"
		ERROR "$i error log"
}

testFunction $@
