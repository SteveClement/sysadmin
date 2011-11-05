#!/bin/sh
#
#

# PROVIDE: agent
# REQUIRE: LOGIN
# BEFORE:  securelevel
# KEYWORD: FreeBSD shutdown

# Add the following line to /etc/rc.conf to enable `agent':
#
#agent_enable="YES"
#

. "/etc/rc.subr"

# Needed for 4.x
##. "/usr/local/etc/rc.subr"


name="agent"
rcvar=`set_rcvar`

command="/etc/bkupexec/agent.be"
pidfile="/var/run/$name.pid"
required_files="/etc/bkupexec/$name.cfg"
command_args="-c $required_files &"

# read configuration and set defaults
load_rc_config "$name"
: ${agent_enable="NO"}

run_rc_command "$1"
