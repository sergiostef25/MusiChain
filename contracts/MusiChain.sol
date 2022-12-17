//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MusiChain {
    address payable public owner;
    mapping(string => mapping(string => Song)) public songs; // una canzone è identificata dalla coppia (NomeArtista, NomeCanzone)
    mapping(address => string) public artists; //Per verificare chi richiama la funzione addArtist non abbia già agggiunto un artista, questo perchè un account può essere associato a solo un artista
    mapping(string => uint) public artistsCheck; //per controllare che il nome dell'artista non sia già stato usato
    mapping(address => string) public users;
    struct Song{
        address payable songOwner; //l'indirizzo dell'artista
        uint[] pricing;
        uint idSong;
    }
    
    uint private idArtist; // id assegnato progressivamente ad ogni artista inserito in MusiChain
    uint private idSong;

    constructor(){
        owner = payable(msg.sender);
        idArtist = 1;
        idSong = 1;
    }

    event rented(address indexed user, string artistName, string songName, uint timeOfPurchase, uint expirationTime, string link_cover);
    event artistAdded(address user, uint indexed idArtist, string artistName, string link_avatar, uint timeOfInsertion); //evento che verrà richiamato all'aggiunta di un nuovo artista in MusiChain
    event songAdded(address indexed user, uint indexed idArtist, uint indexed id_song, string songName, string artistName, string album, string genre, uint year, uint timeOfInsertion, uint[] pricing, string link_file, string link_cover); //evento che verrà richiamato all'aggiunta di una nuova canzone

    modifier costs(string memory artistName, string memory songName, uint option){ // modificatore per il controllo della quantità di ether per procedere all'acquisto della canzone
        uint amount;
        if(option <=4){
            amount = songs[artistName][songName].pricing[option];
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

    function addUser(address userAddress, string memory randomKey) external notOwner{
        users[userAddress] = randomKey;
    }

    function addArtist(string memory artistName, string memory link_avatar) external notOwner{
        require(artistsCheck[artistName] == 0,"Artists already exists"); //controllo che l'artista non sia già stato inserito precedentemente
        require(bytes(artists[msg.sender]).length == 0 ,"You are already an artist"); // controllo che l'account che usa questa funzione non sia già un artista
        artists[msg.sender] = artistName;
        artistsCheck[artistName] = idArtist;
        emit artistAdded(msg.sender, idArtist, artistName , link_avatar, block.timestamp);
        idArtist++;
    }
    
    function addSong(string memory songName, string memory album, string memory genre, uint year, uint[] memory pricing, string[] memory links) external notOwner{
        require(bytes(artists[msg.sender]).length > 0 ,"You are not an artists"); // controllo che chi utilizzi questa funzione sia un artista
        require((songs[artists[msg.sender]][songName].idSong == 0),"Already present"); // controllo che la canzone non sia già inserita
        string memory artistName = artists[msg.sender];
        songs[artistName][songName] = Song(payable(msg.sender), pricing, idSong); //inserisco automaticamente il nome dell'artista, in quanto solo un artista è associato ad un determinato account

        emit songAdded(msg.sender, artistsCheck[artistName],idSong, songName, artistName, album, genre, year, block.timestamp, pricing, links[0], links[1]);
        idSong++;
    }

    function buySong(string memory artistName, string memory songName, uint amountArtist, uint amountMusiChain, uint option, string memory link_cover) external payable costs(artistName, songName, option) notOwner{ 
        require(option>=0 && option<=5, "Not the right option");
        require(songs[artistName][songName].songOwner != msg.sender,"Artist cannot buy its music"); // controllo che l'artsta non compri la sua stessa musica
        (bool sentArtist,) = songs[artistName][songName].songOwner.call{value: (amountArtist)}(""); // invio degli ethers all'account dell'artista
        (bool sentMusiChian,) = owner.call{value: (amountMusiChain)}(""); // invio degli ethers all'acount del proprietario di MusiChain
        require(sentArtist && sentMusiChian,"Fail to send Ether"); // controllo che le operazioni siano andate a buon fine
        if(option == 0){
            emit rented(msg.sender, artistName, songName, block.timestamp, block.timestamp + 1 days, link_cover);
        }else if(option == 1){
            emit rented(msg.sender, artistName, songName, block.timestamp, block.timestamp + (3*1 days), link_cover);
        }else if(option == 2){
            emit rented(msg.sender, artistName, songName, block.timestamp, block.timestamp + 1 weeks, link_cover);
        }else if(option == 3){
            emit rented(msg.sender, artistName, songName, block.timestamp, block.timestamp + (31*1 days), link_cover);
        }else{
            emit rented(msg.sender, artistName, songName, block.timestamp, block.timestamp + (365*1 days), link_cover);
        }
        
    }

}