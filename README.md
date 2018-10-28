# Malware Bash Polimorfo e Stealth con un Keylogger come Payload

Il Malware creato è classificato come Virus Polimorfo, con alcune semplici tecniche per rendere il virus il più stealth possibile con
la massima riduzione possibile delle signature rilevabili, riducendo le possibilità di over-infection. In particolare il virus si diffonde dalla cartella di esecuzione in tutte le subdirectories
"appendendo" il proprio codice criptato ai file *.sh insieme ad una breve routine di decrypt e riordino.
Il payload è costituito in un semplice keylogger che invia ad un server remoto di proprietà dell'attaccante tutti i tasti premuti su una tastiera

## File virus.sh

**DESCRIZIONE:**
Consiste nel "core" del virus. Il file non è criptato (per praticità di lettura) ma esso si diffonde in una versione criptata
all'interno di tutti i file *.sh dalla directory corrente in tutte le subdirectories.
Il payload si trova alla fine del file e avvia la trasmissione dei tasti premuti all'attaccante.

**ISTRUZIONI:**
Avvio dell'infezione:

    ./virus_finale.sh

**(!!ATTENZIONE!!)**
**Può essere dannoso se avviato da una directory contenente file che non si vogliono infettare.**

**COMPORTAMENTO:**
Prima di tutto il virus controlla è stato avviato in modalità test, necessario per capire quando un file è già stato infettato.
Si scartano poi tutti i file con lunghezza inferiore a quella del virus per evitare che esso si auto-infetti.
Si prendono tutti i file *.sh e si inizia ad analizzare se essi contengono già una codifica del virus nell'ultima riga oppure no. Nel
caso la codifica sia presente si passa al file successivo, altrimenti si aggiunge al target corrente il virus criptato utilizzando come password il numero di inode del target stesso.

## File virus_debug.sh 
Analogo a virus_finale_debug.sh ma vengono stampati dei commento sull'stdout per comprendere meglio cosa sta avvenendo


## File attacker.sh 
**DESCRIZIONE:**
Script utilizzato dall'attaccante per mettere in ascolto il proprio server su una data porta (es 4444) e ricevere connessioni dai keylogger avviati dalle vittime.

**ISTRUZIONI:**
Avvio del server:

    ./attacker.sh output_log_file

(necessario passare in output_log_file un file dove loggare tutto ciò che viene ricevuto sulla porta 4444)


## File decode.sh 
**DESCRIZIONE:**
Script utilizzato dall'attaccante per decodificare tutti i keycode premuti e rilasciati sulla macchina vittima e convertirli in caratteri comprensibili.

**ISTRUZIONI:**
Avvio della decodifica di output_log_file:

    ./decode.sh keycode_mapping log_file_to_decode

Il keycode_mapping consiste in un file contente tutta la mappatura keycode->carattere della macchina vittima e viene comunicato all'inizio di ogni connesione ricevuta
da una macchina infettata, mentre log_file_to_decode consiste nel file di log di tutti i keycode premuti e rilasciati sulla macchina vittima.




## COME TESTARE LO SCRIPT:

1) Avviare un terminale attaccante (TERM_ATTACK) e eseguire lo script attacker.sh  (es. ./attacker.sh output_log.txt)
2) Posizionarsi all'intero di una directory da infettare (insieme a tutte le subdirectories). ATTENZIONE A NON AVERE FILE CHE NON SI VOGLIONO INFETTARE ALL'INTERNO
3) Avviare un terminale vittima (TERM_VICT) e eseguire lo script virus_finale.sh (es ./virus_finale.sh)
4) Interompere l'esecuzione dello script in TERM_ATTACK quando voluto.
5) Estrapolare la keycode_map dal log salvato (es. output_log.txt) e il log dei keycode premuti, e salvarli in due file (es. keycode_map.txt e keycode_log.txt)
6) Eseguire lo script decode.sh sul log e ricavare testo leggibile (es. /decode.sh keycode_map.txt keycode_log.txt)


**NOTE:**
Ad infezione avvenuta, qualunque file infettato e avviato da terminale tenterà di connettersi al server attacante e inviare il log dei tasti premuti.


