const Web3 = require('web3');
const MusiChain = require('../build/contracts/MusiChain.json');

const init = async () => {
    const web3 = new Web3('http://localhost:7545');
    const id = await web3.eth.net.getId();
    const deployedNetwork = MusiChain.networks[id];
    const contractMusiChain = new web3.eth.Contract(MusiChain.abi, deployedNetwork.address);

    const addresses = await web3.eth.getAccounts();
    const amount = 0.2;
    const amountArtist = amount*0.98;
    const amountMusiChain = amount*0.02;
    const option = 5;
    contractMusiChain.methods.buySong('Calcutta','Pesto',web3.utils.toWei(amountArtist.toString()),web3.utils.toWei(amountMusiChain.toString()),option)
    .send({from: addresses[5], value: web3.utils.toWei(amount.toString())})
    .then(receipt => {
        console.log(receipt);
    }).catch(error => {
        console.log(error.message);
    });
    
}

init();