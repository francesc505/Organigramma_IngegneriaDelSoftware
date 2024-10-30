# Organigramma
Il codice permette di creare un organigramma. Lo sviluppo è suddiviso in Front-end(Flutter) e Back-end(Spring-Boot).
L'applicazione presenta un'area di login, registrazione , inserimento dei ruoli e unità organizzative. E' possibile associare a ciascuna unità,  i dipendenti suddivisi in gruppi 
e la loro visualizzazione gerarchica, vale a dire, la creazione di un ulteriore organigramma che prende in considerazione solo i dipendenti di quel gruppo ( è possibile con tutti i gruppi.
# FRONT-END:
per poter eseguire l'applicazione, bisogna settare come "DEVICE TO USE" "CHROME" .
Le classi principali si trovano nella cartella lib e \lib\model.

# BACK-END 
Per visualizzare le cartelle che contengono le classi e l'utilizzo dei diversi pattern presenti nel progetto, visualizza: src\main\java\... 

#IMPORTANTE 
modificare il file: "application.properties". Bisogna solo creare un Data Base, e modificare i campi presenti, le tabelle verranno costruite non appena di avvierà il back-end del progetto 

#NOTA
Al fine di utilizzare il DTO e il Mapper, non si è potuta stabilire la relazione tra User e Organigramma in quanto la prima è astratta ( per la corretta impostazione del Patter FACTORY METHOD ), questo crea un  conflitto con la procedura di creazione del Mapper. 
Se non si utilizza il mapper e quindi si "uncomment" , il codice all'interno del DBSave e si commenta il codice che attualmente utilizza i DTO e il Mapper, e eliminando le tabelle, si creano nuovamente tutte le tabelle e in questo caso si va a creare la relazione 
tra User e Organigramma.
