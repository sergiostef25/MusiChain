//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MusiChain {
    address payable public owner;
    mapping(string => mapping(string => Song)) public songs; // una canzone è identificata dalla coppia (NomeArtista, NomeCanzone)
    mapping(address => string) public artists; //Per verificare chi richiama la funzione addArtist non abbia già agggiunto un artista, questo perchè un account può essere associato a solo un artista
    mapping(string => uint) public artistsCheck; //per controllare che il nome dell'artista non sia già stato usato

    struct Song{
        address payable songOwner; //l'indirizzo dell'artista
        string genre;
        string album;
        uint year;
        uint length;
        uint purchasingCost;
        uint rent_oneday;
        uint rent_threedays;
        uint rent_oneweek;
        uint rent_onemonth;
        uint rent_oneyear;
    }
    
    uint private idArtist; // id assegnato progressivamente ad ogni artista inserito in MusiChain


    constructor(){
        owner = payable(msg.sender);
        idArtist = 1;
    }

    event purchased(address indexed user, string artistName, string songName, uint timeOfPurchase); //evento che verrà richiamato ad ogni acquisto di una canzone. Avremo quindi la lista di tutti gli acquisti
    event rented(address indexed user, string artistName, string songName, uint timeOfPurchase, uint expirationTime);
    event artistAdded(address user, uint indexed idArtist, string artistName, uint timeOfInsertion); //evento che verrà richiamato all'aggiunta di un nuovo artista in MusiChain
    event songAdded(address user, uint indexed idArtist ,string songName, string artistName, uint timeOfInsertion); //evento che verrà richiamato all'aggiunta di una nuova canzone

    modifier costs(string memory artistName, string memory songName, uint option){ // modificatore per il controllo della quantità di ether per procedere all'acquisto della canzone
        uint amount;
        if(option == 0){
            amount = songs[artistName][songName].purchasingCost;
        }else if(option == 1){
            amount = songs[artistName][songName].rent_oneday;
        }else if(option == 2){
            amount = songs[artistName][songName].rent_threedays;
        }else if(option == 3){
            amount = songs[artistName][songName].rent_oneweek;
        }else if(option == 4){
            amount = songs[artistName][songName].rent_onemonth;
        }else if(option == 5){
            amount = songs[artistName][songName].rent_oneyear;
        }else{
            amount = 0;
        }
        
        require(msg.value == amount, "It's not the right amount");
        _;
    }

    modifier notOwner{ // modificatore per controllare che l'account proprietario di MusiChain non esegua operazioni non consentite come l'aggiunta di un artista o di una canzone
        require(owner != msg.sender, "MusiChain Owner cannot perfome this");
        _;
    }

    function addArtist(string memory artistName) external notOwner{
        require(artistsCheck[artistName] == 0,"Artists already exists"); //controllo che l'artista non sia già stato inserito precedentemente
        require(bytes(artists[msg.sender]).length == 0 ,"You are already an artist"); // controllo che l'account che usa questa funzione non sia già un artista
        artists[msg.sender] = artistName;
        artistsCheck[artistName] = idArtist;
        idArtist++;
        emit artistAdded(msg.sender, idArtist, artistName ,block.timestamp);
    }
    
    function addSong(string memory songName, string memory genre, string memory album, uint year, uint length) external notOwner{
        require(bytes(artists[msg.sender]).length > 0 ,"You are not an artists"); // controllo che chi utilizzi questa funzione sia un artista
        require((songs[artists[msg.sender]][songName].length == 0),"Already present"); // controllo che la canzone non sia già inserita
        uint purchasingCost = 2000000000000000 wei; // 2,3 euro
        uint rent_oneday = 1000000000000000 wei; // 1,15 euro
        uint rent_threedays = 2500000000000000 wei; //2,87 euro
        uint rent_oneweek = 6000000000000000 wei; //6,89 euro
        uint rent_onemonth = 20000000000000000 wei; //22,98 euro
        uint rent_oneyear = 200000000000000000 wei; //229,75 euro
        songs[artists[msg.sender]][songName] = Song(payable(msg.sender), genre, album, year, length, purchasingCost, rent_oneday, rent_threedays,rent_oneweek,rent_onemonth,rent_oneyear); //inserisco automaticamente il nome dell'artista, in quanto solo un artista è associato ad un determinato account
        string memory artistName = artists[msg.sender];
        emit songAdded(msg.sender, artistsCheck[artistName], songName, artistName, block.timestamp);
    }

    function buySong(string memory artistName, string memory songName, uint amountArtist, uint amountMusiChain, uint option) external payable costs(artistName, songName, option) notOwner{ 
        require(option>=0 && option<=5, "Not the right option");
        require(songs[artistName][songName].songOwner != msg.sender,"Artist cannot buy its music"); // controllo che l'artsta non compri la sua stessa musica
        (bool sentArtist,) = songs[artistName][songName].songOwner.call{value: (amountArtist)}(""); // invio degli ethers all'account dell'artista
        (bool sentMusiChian,) = owner.call{value: (amountMusiChain)}(""); // invio degli ethers all'acount del proprietario di MusiChain
        require(sentArtist && sentMusiChian,"Fail to send Ether"); // controllo che le operazioni siano andate a buon fine
        if(option == 0){
            emit purchased(msg.sender, artistName, songName, block.timestamp);
        }else if(option == 1){
            emit rented(msg.sender, artistName, songName, block.timestamp, block.timestamp + 1 days);
        }else if(option == 2){
            emit rented(msg.sender, artistName, songName, block.timestamp, block.timestamp + (3*1 days));
        }else if(option == 3){
            emit rented(msg.sender, artistName, songName, block.timestamp, block.timestamp + 1 weeks);
        }else if(option == 4){
            emit rented(msg.sender, artistName, songName, block.timestamp, block.timestamp + (31*1 days));
        }else{
            emit rented(msg.sender, artistName, songName, block.timestamp, block.timestamp + (365*1 days));
        }
        
    }

}