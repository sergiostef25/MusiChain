const Web3 = require('web3');
const MusiChain = require('../build/contracts/MusiChain.json');

const init = async () => {
    const web3 = new Web3('http://localhost:7545');

    const id = await web3.eth.net.getId(); //dato che usaimo await inseriamo tutto il codice in una funzione asincrona
    const deployedNetwork = MusiChain.networks[id];
    //abi dice a web3 come comunicare con lo smart contract, sono salvate tutte
    // le funzioni che si possono chiamare
    // address è opzionale perchè si potrebbe deployare già da qui
    const contractMusiChain = new web3.eth.Contract(
        MusiChain.abi,
        deployedNetwork.address
    );

    // Con il codice di sopra creamo un'istanza del contratto

    //Ora vediamo come chimare le funzioni degli smart contract
    const result = await contractMusiChain.methods.owner().call();
    console.log('L\'owner di MusiChain e\':'+result);
}
init();