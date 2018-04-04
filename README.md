### What is dispatcher good for

Dispatcher allows an account to make multiple arbitrary contract call in one transaction.

Instead of broadcasting and paying for multiple transactions with independent inputs and outputs, one may use dispatcher concatenated input data of calls into single transaction that would produce almost same results.

Dispatcher takes serialized array of destination addresses and arguments of calls, then simply forwards them to related contracts. Dispatcher terminates the execution throwing if rollback flag is on and any of call in the array fails.

Using dispatcher, one may save approximately 21000*(n-1) gas for each call where n is number of serialized calls.


### Serialization

In the implementation proposed, each serialized call consist of three parts and formed like below:

`(destinationAddr0, inputLen0, input0, destinationAddr1, inputLen1, input1, .. )`

Destination address, (20 bytes)
Input length, (32 bytes uint)
Input, method signature + method arguments

#### Example

Input of well known erc20 transfer function:

`function transfer(address to, uint256 value) returns (bool){ .. }`

```
"0xa9059cbb000000000000000000000000712643339c507090122f0145470f529f3dd763bc0000000000000000000000000000000000000000000000000000000000001388"
```


In order to dispatch a erc20 transfer call, input content should be concatenated like this:

`function forwardBatch(bytes _input, bool rollback) { .. }`

```
// destination (contract) address
"0x6037bb425b00a0b01a1cd1ffd9cb33089832a114" +

// input length
"0000000000000000000000000000000000000000000000000000000000000048" +

// input
"0xa9059cbb000000000000000000000000712643339c507090122f0145470f529f3dd763bc0000000000000000000000000000000000000000000000000000000000001388"
```
