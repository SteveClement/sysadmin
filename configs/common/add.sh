/usr/bin/x2vnc -east dia:0 -passwd .vnc/passwd-ion  2> /dev/null &
SSH_ASKPASS="/usr/bin/gtk2-ssh-askpass"
sshadd="/usr/bin/ssh-add /home/jedi/.ssh/newkey.openssh"
$sshadd
