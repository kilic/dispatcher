var Dispatcher = artifacts.require("Dispatcher");
var Storage = artifacts.require("Storage");
var NeverSatisfy = artifacts.require("NeverSatisfy");

contract('Rollback test', function (accounts) {

	const UINT_1 = 12;
	const ADDR_1 = "0x712643339c507090122f0145470f529f3dd763bc";
	const BYTES_1 = "0x66dd12";

	before(async function () {

    	StorageDummy = await Storage.new();
    	StorageTest = await Storage.new();
    	NeverSatisfy = await NeverSatisfy.new();
    	var tx1 = await StorageDummy.setUint(UINT_1);
		var tx2 = await StorageDummy.setAddr(ADDR_1);
		var tx3 = await StorageDummy.setBytes(BYTES_1);
		var input1 = web3.eth.getTransaction(tx1.tx).input;
		var input2 = web3.eth.getTransaction(tx2.tx).input;
		var input3 = web3.eth.getTransaction(tx3.tx).input;
		input1 = StorageTest.address 				+ web3.padLeft(web3.toHex((input1.length/2)-1).substr(2),64) + input1.substr(2);
		input2 = StorageTest.address.substr(2)	 	+ web3.padLeft(web3.toHex((input2.length/2)-1).substr(2),64) + input2.substr(2);
		input3 = StorageTest.address.substr(2) 		+ web3.padLeft(web3.toHex((input3.length/2)-1).substr(2),64) + input3.substr(2);
		input4 = NeverSatisfy.address.substr(2)		+ web3.padLeft(web3.toHex((input3.length/2)-1).substr(2),64) + input3.substr(2);
		input = input1 + input2 + input3 + input4;
  	});


    it("Transaction should have been reverted", async function(){


    	let dispatcher = await Dispatcher.deployed();
        try{
        	await dispatcher.forwardBatch(input,true);
            assert.fail();
        } catch (err) {
            assert.ok(/revert/.test(err.message))
        }
    });


    it("Values in test storage must be 0x0", async function(){

        StorageTest.getUint().then(function(value){
            assert.equal(value.valueOf(),0);
        });

        StorageTest.getAddr().then(function(value){
            assert.equal(value.valueOf(),"0x0000000000000000000000000000000000000000");
        });

        StorageTest.getBytes().then(function(value){
            assert.equal(value.valueOf(),"0x");
        });
    });

});