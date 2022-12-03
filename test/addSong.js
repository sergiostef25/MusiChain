const Web3 = require('web3');
const MusiChain = require('../build/contracts/MusiChain.json');


const init = async () => {
    const web3 = new Web3('http://localhost:7545');
    const id = await web3.eth.net.getId();
    const deployedNetwork = MusiChain.networks[id];
    const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);

    const addresses = await web3.eth.getAccounts();
    const pricing = [0.001,0.0025,0.006,0.02,0.2];
    pricing.forEach(toWei);

    function toWei(item, index, arr) {
        arr[index] = web3.utils.toWei(item.toString());
      }
    const urls = ["https://firebasestorage.googleapis.com/v0/b/musichain-9d5bb.appspot.com/o/calcutta_delverde.mp3?alt=media&token=e07fca80-5178-4401-bc94-3f13209595c5","https://firebasestorage.googleapis.com/v0/b/musichain-9d5bb.appspot.com/o/calcutta_delverde_cover.jpg?alt=media&token=553a896d-c256-4280-95f4-384da80c641d"];
    
    contractMusiChain.methods.addSong('Del Verde', 'Evergreen', 'Indie', 2018, pricing, urls).send({from: addresses[1], gas: 700000})
    .then(receipt => {
        console.log(receipt);
    }).catch(error => {
        console.log(error.message);
    });
} 

init();