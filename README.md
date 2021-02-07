# Go-ETHereum 
본 실습은 geth와 web3 공식 문서들을 바탕으로 재구성되었습니다.


#| tasks
----|--------------
1| [Geth 설치 / Test Network 접속 / Console 접속](#assignment-1)
2| [계정 생성 / faucet / 송금 / 잔액 확인](#assignment-2)
3| [스마트 컨트랙트 작성 / 배포](#assignment-3)

<https://geth.ethereum.org/docs/getting-started>

<https://web3js.readthedocs.io/en/v1.3.0/web3.html>

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

* [NOTICE] IPC endpoint는 다를 수 있으므로 1.33에서 꼭 확인

## 1.5. 접속된 네트워크의 IPC endpoint url(1.33 참고)과 Geth Console의 datadir 일치여부 확인
![15](https://user-images.githubusercontent.com/70181621/107147360-f3b71080-6990-11eb-81c5-748b51d5ec38.png)


***
# Assignment 2.
1. 계정 생성
2. 계정 확인
3. Faucet
4. 송금 (트랜잭션)
5. 계정 잔액 확인


## 2.1. Test Network 및 Console 접속
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
