#!/bin/bash

OPERATION=$1
IDENT=$2
PASS=$3

# estas duas variáveis definem o nome dos arquivos de senhas e identificadores de senhas
passFile="passwords"
indentifierFile="identis"

touch $passFile
touch $indentifierFile

logo () {
cat << "EOF"
  /$$$$$$  /$$                             /$$                        
 /$$__  $$| $$                            | $$                        
| $$  \__/| $$$$$$$   /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$ 
| $$      | $$__  $$ /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$      | $$  \ $$| $$$$$$$$|  $$$$$$   | $$    | $$$$$$$$| $$  \__/
| $$    $$| $$  | $$| $$_____/ \____  $$  | $$ /$$| $$_____/| $$      
|  $$$$$$/| $$  | $$|  $$$$$$$ /$$$$$$$/  |  $$$$/|  $$$$$$$| $$      
 \______/ |__/  |__/ \_______/|_______/    \___/   \_______/|__/      
                                                                                                                                            
EOF
}

manual () {
	clear
	logo
	echo -e "\nSeja bem vindo ao chester."
	echo "Este shell script não é 100% seguro, não utilize-o para guardar senhas altamente importantes como senhas bancárias."
	echo "Se for hackeado, troque suas senhas que guardou no arquivo."

	echo -e "\n<operação> <identificador> <senha>"
	echo "Operações aceitas:"
	echo -e "\t-S\t: Salvar uma senha, recebe como parâmetro o identificador e a senha a ser salva."
	echo -e "\t-Da\t: Limpa TODAS as suas senhas."
	echo -e "\t-Do\t: Limpa apenas um, que precisa ser especificado no identificador."
	echo -e "\t-M\t: Mostra o manual."
	echo -e "\t-Vc\t: Copia para sua área de transferência."
}

savePasswd () {
	echo "$PASS" >> $passFile
	echo "$IDENT" >> $indentifierFile
	
	clear
	logo
	echo "[-] Senha salva... [-]"
}

viewAndCopy () {
	linha=$(cat identis | grep -n "$IDENT" | cut -f1 -d":")	
	cat passwords | head -$linha | tail -1 | xclip -selection clipboard

	clear
	logo
	echo "[-] Senha para $IDENT já está na sua área de transferência [-]"
}

resetFiles () {
	rm $passFile
	touch $passFile

	rm $indentifierFile
	touch $indentifierFile
}

removeOne () {
	linha=$(cat identis | grep -n "$IDENT" | cut -f1 -d":")
	
	sed -i $linha'd' $indentifierFile
	sed -i $linha'd' $passFile
	
	clear
	logo
	echo "[-] $IDENT foi excluído das suas senhas [-]"
}	



if [ -z ${OPERATION} ] || [ $OPERATION == "-M" ]
then
	manual
	exit
fi

if [ $OPERATION == "-S" ] && [ -n ${IDENT} ] && [ -n "${PASS}" ]
then
	savePasswd
	exit
fi

if [ $OPERATION == "-Da" ]
then
	resetFiles
	exit
fi

if [ $OPERATION == "-Do" ] && [ -n $IDENT ]
then
	removeOne
	exit
fi

if [ $OPERATION == "-Vc" ] && [ -n $IDENT ]
then
	viewAndCopy
	exit
fi
