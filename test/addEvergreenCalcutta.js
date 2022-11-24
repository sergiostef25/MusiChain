const Web3 = require('web3');
const MusiChain = require('../build/contracts/MusiChain.json');

const songList = ['Briciole','Paracetamolo','Pesto','Kiwi','Saliva','Dateo','Hubner','Nuda nudissima','Rai','Orgasmo'];
const songLength = [216,178,207,222,186,75,187,203,225,200];

const init = async () => {
    const web3 = new Web3('http://localhost:7545');
    const id = await web3.eth.net.getId();
    const deployedNetwork = MusiChain.networks[id];
    const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);

    const addresses = await web3.eth.getAccounts();

    for(let i=0; i<songList.length; i++){
        contractMusiChain.methods.addSong(songList[i], 'Indie', 'Evergreen', 2018, songLength[i]).send({from: addresses[1], gas: 300000})
        .then(receipt => {
            console.log(receipt);
        }).catch(error => {
            console.log(error.message);
        });
    }



}

init();