#!/bin/bash

DATEHOUR=$(date +%Y-%m-%d-%Hh%M)

NUMBER=$(( $RANDOM % 20 + 1 ))

LOG=/var/log/rotate_motd/log_$DATEHOUR.log

touch $LOG

if [ $# -eq 1 ]
then
	if [ $1 == "cmd" ]
	then
		echo "L'utilisateur $USER entre dans l'invite" >> $LOG
		echo "Que faire ?"
		echo "change : modifier le chemin de la liste de motd"
		echo "quit : quitter l'invite de commande"
		read ANSWER
		if [ $ANSWER == "change" ]
		then
			echo "$USER entre 'change'" >> $LOG
			read "Le chemin ? N/n pour arrêter" ANSWER
			if [ $ANSWER == "n" ] || [ $ANSWER == "N" ]
			then
				echo "Arrêt de l'invite" >> $LOG
			else
				echo $ANSWER > $CONFG_PWD
			fi
		else
			echo "Argument incorrect"
		fi
	elif [ $1 == "start" ]
	then

		echo "Début du script" > $LOG

		echo "On sauvegarde l'ancien motd" >> $LOG

		cp /etc/motd /srv/rotate_motd/oldMOTD/motd_$DATEHOUR 2>> $LOG

		if [ $? = 0 ]
		then
			echo "On copie le nouveau motd" >> $LOG
			cp /srv/rotate_motd/lib/$NUMBER /etc/motd 2>> $LOG
			if [ $? != 0 ]
			then
				echo "Impossible de copier le nouveau motd" >> $LOG
			fi
		else
			echo "La sauvegarde de l'ancien motd a échoué. Arrêt..." >> $LOG
		fi

	elif [ $1 == "stop" ]
	then
		echo "La fonctionnalité n'a pas encore été développée"
	else
		echo "Argument incorrect"
	fi
elif [ $# -gt 1 ]
then
	echo "Un seul argument possible"
else
	echo "Un argument est nécessaire"
fi
