# compilers-project

ARQUIVOS GERADOS AO COMPILAR:

	parser.y	: 	parser.tab.h ; parser.tab.c
	lexer.l		: 	lex.yy.c
____________________________________________________________________________


INSTRUÇÕES:

1. Abra o arquivo "makeFiles.bat" para rodar automaticamente as linhas 
de comando corretas para compilar todos os arquivos necessários.

2. Ao executar o arquivo "program.exe", já é possível usar a linguagem
no próprio terminal.

3. Para rodar um algoritmo salvo em um arquivo "example.txt" dentro da 
pasta do projeto, abra o terminal de comandos no diretório do próprio
projeto, e faça: 

program.exe < example.txt
