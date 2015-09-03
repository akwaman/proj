shell: shell.c
	gcc shell.c -o shell

examine: shell
	objdump -d shell | sed -n '/needle0/,/needle1/p' 
