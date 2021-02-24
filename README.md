# Go-ETHereum 
본 실습은 [geth](https://geth.ethereum.org/docs/getting-started)와 [web3](https://web3js.readthedocs.io/en/v1.3.0/web3.html) 공식 문서들을 바탕으로 재구성되었습니다.


#| tasks
----|--------------
1| [Geth 설치](#12-개발환경-세팅) / [Test Network 접속](#13-test-network-접속) / [Console 접속](#14-geth-console-접속-ipc-이용)
2| [계정 생성](#22-계정-생성-및-확인) / [faucet](#23-faucet) / [송금](#24-계정0에서-계정1로-송금) / [잔액 확인](#27-계정-잔액-확인)
3| [스마트 컨트랙트 작성](#32-스마트-컨트랙트-작성) / [컴파일](#33-beyondsol을-ABI와-bytecode로-컴파일) / [배포](#37-배포를-위한-parameter-정의)


***

# Assignment 1.
1. Geth 설치
2. Test Network 접속
3. Geth Console 접속


## 1.1. Cloud 접속
```
ssh root@주소
```



## 1.2. 개발환경 세팅
### 1.21. Geth
```
sudo add-apt-repository -y ppa:ethereum/ethereum
```
```
sudo apt-get update
sudo apt-get install ethereum
```
<https://geth.ethereum.org/docs/install-and-build/installing-geth>
### 1.22. Node.js & npm
```
sudo apt-get update 
sudo apt-get upgrade
sudo apt-get install nodejs
```
```
sudo apt-get install npm
```

### 1.23. Go-lang
```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install golang
```

### 1.24. web3
```
sudo apt-get install npm
```


## 1.3. Test Network 접속
### 1.31. Default (syncmode "fast")

network| command
----|-----------
Main| ```geth console```
Ropsten| ```geth --ropsten```
Görli| ```geth --goerli```


### 1.32. 추가 명령어를 통해 syncmode 조정 가능

network| command
----|-----------
Ropsten| ```geth --ropsten --syncmode "full" --rpc --signer=</usr/bin/clef>/clef.ipc```
Görli| ```geth --goerli --syncmode "light" --rpc --signer=</usr/bin/clef>/clef.ipc```

* sync를 full, fast, light로 바꿔가면서 차이점 파악
* [NOTICE] signer 주소는 다를 수 있으므로 clef 위치를 꼭 확인
* clef 위치 확인방법 > ```clef```

![clef](https://user-images.githubusercontent.com/70181621/107146305-94ee9880-698a-11eb-835e-f16f08679afd.png)


### 1.33. IPC url 확인 
- Test Network에 성공적으로 접속되면 확인가능
![ropsten](https://user-images.githubusercontent.com/70181621/107146184-d599e200-6989-11eb-80a9-ee84a53c4e6d.png)

## 1.4. Geth Console 접속 (IPC 이용)
- 1.3에서 네트워크를 접속한 Terminal과 다른 Terminal에서 접속

network| commands
----|-----------
Main| ```geth attach```
Ropsten| ```geth attach /root/.ethereum/ropsten/geth.ipc```
Görli| ```geth attach /root/.ethereum/goerli/geth.ipc```

* [NOTICE] IPC endpoint는 다를 수 있으므로 [1.33](#133-ipc-url-확인)에서 꼭 확인

## 1.5. 접속된 네트워크의 [IPC endpoint url](#133-ipc-url-확인)과 Geth Console의 datadir 일치여부 확인
![15](https://user-images.githubusercontent.com/70181621/107147360-f3b71080-6990-11eb-81c5-748b51d5ec38.png)


***
# Assignment 2.
1. 계정 생성
2. 계정 확인
3. Faucet
4. 송금 (트랜잭션)
5. 계정 잔액 확인


## 2.1. [Test Network](#13-test-network-접속) 및 [Console](#14-geth-console-접속-ipc-이용) 접속
Assignment 1 참고

## 2.2. 계정 생성 및 확인
### 2.21. 계정 생성
```
web3.eth.accounts.create()
``` 
or
```
web3.eth.personal.newAccount()
```

<https://web3js.readthedocs.io/en/v1.2.0/web3-eth-accounts.html#create>

### 2.22. 계정 확인
```
web3.eth.accounts
``` 
or 
```
web3.eth.personal.listAccounts
```

## 2.3. Faucet
- Görli: <https://goerli-faucet.slock.it/>
- Ropsten: <https://faucet.dimensions.network/> 
- 가끔 faucet이 되지 않는 에러가 있으므로, 그럴 땐 다른 Test Network에서 시도

## 2.4. 계정[0]에서 계정[1]로 송금
```
web3.eth.sendTransaction({from: personal.listAccounts[0], to: personal.listAccounts[1], value: web3.toWei(0.1, "ether")})
```

- 단위가 wei로 표시되지 않게 조심할 것

<https://web3js.readthedocs.io/en/v1.2.0/web3-eth.html#sendtransaction>


## 2.5. 계정 unlock
```
web3.eth.personal.unlockAccount(eth.accounts[0])
```

<https://web3js.readthedocs.io/en/v1.2.0/web3-eth-personal.html#unlockaccount>
- unlock을 하지 않으면 송금 불가능
     
## 2.6. 계정[0]에서 계정[1]로 다시 송금 
```
web3.eth.sendTransaction({from: personal.listAccounts[0], to: personal.listAccounts[1], value: web3.toWei(0.1, "ether")})
```

## 2.7. 계정 잔액 확인
- ```web3.eth.getBalance(personal.listAccounts[0])```는 wei로만 확인가능

- ```web3.fromWei(eth.getBalance(personal.listAccounts[0]), "ether")```는 ETH로 확인가능
        
## 2.8. Transaction Receipt 출력
```
web3.eth.getTransactionReveipt("/*2.6에서 출력된 트랜잭션 hash*/")
```

- blockHash, blockNumber, from, to, transactionHash 확인
![Assignment2_이주연_1](https://user-images.githubusercontent.com/70181621/107146953-af2a7580-698e-11eb-82e9-b6fb4c8f49aa.png)
https://web3js.readthedocs.io/en/v1.2.0/web3-eth.html#gettransactionreceipt

## 2.9. Block Explorer에서 Tx 확인 
- Görli: <https://goerli.etherscan.io>
- Ropsten: <https://ropsten.etherscan.io/>

### 2.91. address, blockNumber 또는 Tx Hash로 검색
### 2.92. 계정 생성 Tx과 송금 Tx 확인
![Assignment2_이주연_2](https://user-images.githubusercontent.com/70181621/107146971-c1a4af00-698e-11eb-9c86-72e1ff349a43.png)

***
# Assignment 3.
1. 스마트 컨트랙트 작성
2. 컴파일
3. 배포


## 3.1. Solidity Compiler 설치
```
npm install -g solc
```

## 3.2 스마트 컨트랙트 작성
작성 조건
1) 각각의 constant가 다음과 같은 값을 return하도록 할 것
2) 입력: ```beyond.showWhoWeAre()```  //  출력: ```"We are Team BEYOND!"```
3) 입력: ```beyond.cleaner("아무 값이나 입력해도 값이 나오지 않게")```  // 출력: ```""```
4) 파일명: beyond.sol


```
// this is beyond.sol

pragma solidity 0.5.16;

contract teamBeyond {
  string internal constant seeWhoWeAre = "We are Team BEYOND!";
  string internal chainResult;

  function beyond(string memory _chainResult) public {
    chainResult = _chainResult;
  }

  function showWhoWeAre() external pure returns (string memory) {
    return seeWhoWeAre;
  }

  function cleaner(string calldata _chainEntry) external view returns (string memory) {
// completely disregard the _chainEntry
    return chainResult;
  }
} 
```

## 3.3 beyond.sol을 ABI와 bytecode로 컴파일
```
// ABI

solc --abi beyond.sol
```
```
// bytecode

solc --bin beyond.sol
```

## 3.4 [네트워크 실행](#13-test-network-접속) 및 [Console](#14-geth-console-접속-ipc-이용) 접속
Assignment 1 참고

## 3.5 bytecode와 ABI 객체 정의
```
bytecode = '0x/*STEP 3 결과 입력*/'
```
```
obj = JSON.parse('/*STEP 3 결과 입력*/')
```

- 본 guideline에서는 편의를 위해 변수를 위와 같은 이름으로 선언하여 계속 사용함
- [JSON.parse](https://www.npmjs.com/package/parse-json) 설치 (STEP 3에서 얻은 ABI는 string. 그러나 geth 콘솔에서 컨트랙트 생성할 때 parameter는 JS배열 > 파싱 필요)

참고자료
- [컨트랙트 생성 시, parameter는 JS배열](https://web3js.readthedocs.io/en/v1.2.1/web3-eth-contract.html)
- [parsing하지 않고 정의 시, 에러 발생](https://github.com/trufflesuite/truffle-artifactor/issues/9)
- [3.3 결과를 잘못 입력 시, 에러 발생](https://stackoverflow.com/questions/56126313/json-expecting-eof-got)

## 3.6 parsing한 ABI 객체로 컨트랙트 객체 생성
```
// web3 v0.x 문법 (공식 docs에 없음)

contractObj = web3.eth.contract(obj)
```
```
// web3 v1.x 문법

contractObj = new web3.eth.Contract(obj)
```
- 컨트랙트 객체를 만들어야 interact가 용이 (개별 스마트 컨트랙트에 json interface를 부여하기 때문: web3가 자동으로 low level인 ABI call을 RPC로 바꿔서 표기)

## 3.7 배포를 위한 parameter 정의
```
deployObj = {from:eth.coinbase, data: bytecode, gas:2000000}
```

## 3.8 컨트랙트 인스턴스 생성 및 배포
```
Instance = contractObj.new(deployObj)
```

## 3.9 계정 [unlock](#25-계정-unlock)

## 3.10 컨트랙트 인스턴스 생성 및 배포
- Transaction Hash [확인가능](#28-transaction-receipt-출력) (컨트랙트 생성 트랜잭션이기 때문)
- 컨트랙트는 배포되어 채굴된 이후에 주소 생성
- Etherscan에서 Transaction Hash로 검색하면, 해당 트랜잭션이 본인 계정 주소에서 보낸 'Contract Creation'임을 확인 가능

## 3.11 Transaction Receipt에서 컨트랙트 주소 확인
```
eth.getTransactionReceipt(Instance.transactionHash)
```

## 3.12 컨트랙트 주소 정의
```
address = eth.getTransactionReceipt(Instance.transactionHash).contractAddress
```

## 3.13 컨트랙트 객체 정의
```
beyond = contractObj.at(address)
```

## 3.14 beyond.showWoWeAre()과 beyond.cleaner("/*아무거나 입력*/") 출력 
```
beyond.showWoWeAre()
```
```
beyond.cleaner("아무거나 입력해서 확인")
```

![Assignment3_이주연](https://user-images.githubusercontent.com/70181621/108871250-4e609580-763c-11eb-8391-6201d130b33f.png)
