# Popis

docker projekt pre import CSV suborov zasielany Stredoslovenskou Distribuciou do MySQL databazy.
To umozni ich naslednu analyzu napr. v Grafana

## spustenie Docker kontajnerov
v root adresari projektu spustit:

    docker-compose up -d

pripadne, pre nuteny build (v pripade zmeny struktury DB a pod):
    
    docker-compose up -d --force-recreate --build

## stopnutie Docker kontajnerov
v root adresari projektu spustit:

    docker-compose down
    
## SSDfiles 
Do adresara SSDFiles sa davaju csv subory posielane SSD distribuciou.
Adresar je v 5 minutovych intervaloch kontrolovany na nove subory a tie su dohrate do MySQL databazy

### SSD na zdielanom disku.
je mozne SSD subory mat aj na zdelanom disku (NAS, alebo ulozisko, kde sa synchronizuje google drive alebo onedrive a pod.) . V tom pripade je potrebne mat nastavenia v docker-compose.yml:

        volumes:
          - ./phpScripts:/phpScripts:ro
          #kde su ulozene subory z SSD a ich mapovanie do kontajnera
          #- ./SSDfiles:/SSD
          #mapujeme zo sharovaneho disku
          - data:/SSD
    volumes:
      my-db:
      data:
        driver: local
        driver_opts:
          type: cifs
          device: "//192.168.x.x/home/SSD"
          o: "username=uszivatel,password=heslo,uid=1000,gid=1000"

## .env
subor, kde su ulozene mena/hesla pre pristup do MySQL databazy. pri vytvoreni docker kontajnera sa nastavia udaje podla tu ulozeneho suboru

# prerequisities

- nainstalovany [docker](https://www.docker.com/)
## KONFIGURACIA
### MySQL
**v roote projektu musi byt adresar mysqlData** - TREBA HO RUCNE VYTVORIT! (docker na NAS ho nevytvori automaticky, na Ubuntu ano)

**v subore dbstructure.sql na konci treba zmenit EIC Vaseho odberneho miesta!**

standardne bezi na porte **3306** ten je mozne podla potreby zmenit v subore docker-compose.yml 

    ports:
      # <Port exposed> : <MySQL Port running inside container>
      #prve cislo je externy port, kde je Mysql
      - '3306:3306'
    expose:
      # Opens port 3306 on the container
      #cislo portu mysql z externeho prostredia
      - '3306'

v prvej casti 'ports' "3306:3306" je potrebne zmenit prve cislo portu
a v casti 'expose' tiez rovnake cislo portu.

pokial sa v docker-compose.yml zmeni cislo portu je potrebne ho zmenit aj v "phpScripts/settings.php"
    
    $dbServer = 'db';

kde ho doplnime za meno servera, napr:

    $dbServer = 'db:3307';

#### pristup na MySQL
Pristup je mozny cez lubovolneho klienta, ktory podporuje MySQL. pristupove meno/heslo je uvedene je v subore docker-compose.yml 


