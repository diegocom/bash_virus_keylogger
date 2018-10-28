#ISTRUZIONI:
#Avvio del server:
#./attacker.sh output_log_file
#(necessario passare in output_log_file un file dove loggare tutto ciò che viene ricevuto sulla porta 4444)
nc -lv -k 4444 >> $1 2>> $1
