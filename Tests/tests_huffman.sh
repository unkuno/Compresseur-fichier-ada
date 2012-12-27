#!/bin/bash

EXE=../tp_huffman

erreur=""

if [ $# = 0 ] ; then
	## Si on a pas d'arguments et bien ..
	## On traite tous les fichiers .txt du répertoire courant
	for arg in $(ls | egrep .txt$); do
		./tests_huffman.sh $arg
	done;

else
	    echo "[ Test $1 ]"
	    $EXE -c $1 $1.comp
	    $EXE -d $1.comp $1.comp.txt
	    ok=$(diff $1 $1.comp.txt)
	    echo ""
	    
	    if [ "$ok" = "" ] ; then
		echo "[ Resultat OK : $1 et $1.comp.txt sont IDENTIQUES ]"
	    else
		echo "[ Resultat KO : $1 et $1.comp.txt sont DIFFERENTS ]"
		erreur+=$1+" ";
	    fi
	    echo ""
fi ;

