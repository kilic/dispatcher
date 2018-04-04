var Dispatcher = artifacts.require("Dispatcher");
var Storage = artifacts.require("Storage");

contract('Dispatch forwarding test', function (accounts) {

	//web3.utils.randomHex(32)
	const UINT = 12;
	const ADDR = "0x712643339c507090122f0145470f529f3dd763bc";
	const BYTES = "0x66dd12";

	before(async function () {

    	Storage1 = await Storage.new();
    	Storage2 = await Storage.new();
    	var tx1 = await Storage1.setUint(UINT);
		var tx2 = await Storage1.setAddr(ADDR);
		var tx3 = await Storage1.setBytes(BYTES);
		var input1 = web3.eth.getTransaction(tx1.tx).input;
		var input2 = web3.eth.getTransaction(tx2.tx).input;
		var input3 = web3.eth.getTransaction(tx3.tx).input;
		input1 = Storage2.address 			+ web3.padLeft(web3.toHex((input1.length/2)-1).substr(2),64) + input1.substr(2);
		input2 = Storage2.address.substr(2) + web3.padLeft(web3.toHex((input2.length/2)-1).substr(2),64) + input2.substr(2);
		input3 = Storage2.address.substr(2) + web3.padLeft(web3.toHex((input3.length/2)-1).substr(2),64) + input3.substr(2);
		input = input1 + input2 + input3;
  	});

	
    it("initial parameters should have been set as expected",  async function () {
		
    	assert.equal(UINT, await Storage1.getUint());
    	assert.equal(ADDR, await Storage1.getAddr())
		assert.equal(BYTES, await Storage1.getBytes())
    });


    it("data in storage 1 & 2 should be equal", async function(){


    	let dispatcher = await Dispatcher.deployed();
    	let tx = await dispatcher.forwardBatch(input,true);


    	Storage1.getUint().then(function(valueX){
			Storage2.getUint().then(function(valueY){
				assert.equal(valueX.valueOf(), valueY.valueOf(), "Uint is not equal")
			});
		});

		Storage1.getAddr().then(function(valueX){
			Storage2.getAddr().then(function(valueY){
				assert.equal(valueX.valueOf(), valueY.valueOf(), "Addr is not equal")
			});
		});

		Storage1.getBytes().then(function(valueX){
			Storage2.getBytes().then(function(valueY){
				assert.equal(valueX.valueOf(), valueY.valueOf(), "Bytes is not equal")
			});
		});

    	//assert.equal((await Storage1.getUint()).valueOf(),(await Storage2.getUint()).valueOf());
    	

    });
});
