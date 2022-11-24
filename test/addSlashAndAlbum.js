const Web3 = require('web3');
const MusiChain = require('../build/contracts/MusiChain.json');

const songList = ['Apocalyptic Love ','One Last Thrill','Standing in the Sun ','You\'re a Lie ','No More Heroes','Halo','We Will Roam','Anastasia','Not for Me','Bad Rain','Hard & Fast','Far and Away','Shots Fired'];
const songLength = [208,189,243,230,263,202,289,367,321,224,182,314,228];

const init = async () => {
    const web3 = new Web3('http://localhost:7545');
    const id = await web3.eth.net.getId();
    const deployedNetwork = MusiChain.networks[id];
    const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);

    const addresses = await web3.eth.getAccounts();

    contractMusiChain.methods.addArtist('Slash').send({from: addresses[3]})
    .then(receipt => {
        console.log(receipt);
    }).catch(error => {
        console.log(error.message);
    });

    for(let i=0; i<songList.length; i++){
        contractMusiChain.methods.addSong(songList[i], 'Hard Rock', 'Apocalyptic Love', 2012, songLength[i]).send({from: addresses[3], gas: 300000})
        .then(receipt => {
            console.log(receipt);
        }).catch(error => {
            console.log(error.message);
        });
    }



}

init();