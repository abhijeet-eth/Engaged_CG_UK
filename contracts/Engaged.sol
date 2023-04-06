// SPDX-License-Identifier: MIT
pragma solidity >=0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Engaged is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    struct TokenDetails{
        uint id;
        address owner;
        uint level;
        uint lastUpgradeTime;
        string courseStatus;
        bool readyForUpdate;
    }

    TokenDetails public tokenDetails;

    address[] public whitelistAddresses;

    mapping(address => bool) whitelist;
    mapping(uint => TokenDetails) public tokenRegistry;
    
    event Attest(address indexed to, uint256 indexed tokenId);
    event Revoke(address indexed to, uint256 indexed tokenId);
    event lastUpdated(uint tokenId, uint snapshot, string _courseStatus);


    string[] level0 = [
        "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level0%20%281%29.json",
        "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level0%20%282%29.json",
        "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level0%20%283%29.json"
    ];

    string[] level1 = [
    "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level1%20%281%29.json",
    "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level1%20%282%29.json",
    "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level1%20%283%29.json"
    ];

    string[] level2 = [
    "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level2%20%281%29.json",
    "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level2%20%282%29.json",
    "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level2%20%283%29.json"   
    ];

    string[] level3 = [
    "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level3%20%281%29.json",
    "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level3%20%282%29.json",
    "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level3%20%283%29.json"    
    ];

    string[] level4 = [
     "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level4%20%281%29.json",
     "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level4%20%282%29.json",
     "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level4%20%283%29.json"  
    ];

    string[] level5 = [
    "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level5%20%281%29.json",
    "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level5%20%282%29.json",
    "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level5%20%283%29.json"
    ];    

    string[] level6 = [
    "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level6%20%281%29.json",
    "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level6%20%282%29.json",
    "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/level6%20%283%29.json"
    ];

    string GODLevel = "https://gateway.pinata.cloud/ipfs/QmNRPMoUtRjv2gqShWBGbPWnm2EfNSBCZYTK8Q5Ro3rKNV/GokuGODLevel7.json";


    

    constructor() ERC721("Soulbound", "SBT") {}

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();

        tokenRegistry[tokenId].id = tokenId;
        tokenRegistry[tokenId].owner = to;
        tokenRegistry[tokenId].level = 0;
        tokenRegistry[tokenId].lastUpgradeTime = block.timestamp;
        tokenRegistry[tokenId].courseStatus = "Enrolled";
        tokenRegistry[tokenId].readyForUpdate = false;

        addToWhitelist(to);

        uint randomNum = random();

        _safeMint(to, tokenId);
        _setTokenURI(tokenId, level0[randomNum]);

        emit lastUpdated(tokenId, block.timestamp, tokenRegistry[tokenId].courseStatus);
    }

    function burn(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Only owner of the token can burn it");
        _burn(tokenId);
    }

    function revoke(uint256 tokenId) external onlyOwner {
        _burn(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256,uint256 batchSize) pure override internal {
        require(from == address(0) || to == address(0), "Not allowed to transfer token");
    }

    function _afterTokenTransfer(address from, address to, uint256 tokenId,uint256 batchSize) override internal {

        if (from == address(0)) {
            emit Attest(to, tokenId);
        } else if (to == address(0)) {
            emit Revoke(to, tokenId);
        }
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function changeUpradeStatus(uint tokenId) public{
        // trigger action 
        // .
        // .
        // .

        tokenRegistry[tokenId].readyForUpdate = true;
    }



    function addToWhitelist(address toAddAddress) 
    internal onlyOwner
    {
        (bool _isWhitelist, ) = isWhitelisted(toAddAddress);
       if(!_isWhitelist) {
            whitelist[toAddAddress] = true;
            whitelistAddresses.push(toAddAddress);
        }    
    }

    /**
     * @notice Remove from whitelist
     */

    //index id of address that is to be removed is replaced by the last index address, and 
    // last index address is poped
    function removeFromWhitelist(address toRemoveAddress)
       public
   {
       (bool _isWhitelist, uint256 s) = isWhitelisted(toRemoveAddress);
       if(_isWhitelist){

           whitelist[toRemoveAddress] = false;

           whitelistAddresses[s] = whitelistAddresses[whitelistAddresses.length - 1];
           whitelistAddresses.pop();
       }
   }

   function isWhitelisted(address _isWhitelisted)
       public
       view
       returns(bool, uint256)
   {
       for (uint256 s = 0; s < whitelistAddresses.length; s += 1){
           if (_isWhitelisted == whitelistAddresses[s]) return (true, s);
       }
       return (false, 0);
   }


    function getWhiltelistedAddresses() public view returns(address[] memory){
        // address[] memory _whitelistAddresses = new 
        return whitelistAddresses;        
    }

    /**
     * @notice Function with whitelist
     */
    function whitelistFunc() public view 
    {
        require(whitelist[msg.sender], "NOT_IN_WHITELIST");

        // Do some useful stuff
    }


    //***************Dynamic NFT Functions***************//

    function random() public view returns(uint){
        return (block.prevrandao) % 3;
    }

    function upgradeNFT(uint _tokenId) public onlyOwner {

        require(block.timestamp > tokenRegistry[_tokenId].lastUpgradeTime + 2,"Cooling time, Can't upgrade now");
        require(tokenRegistry[_tokenId].level < 6, "Highest level reached, no upgrades available !!");

        uint currentLevel = tokenRegistry[_tokenId].level;
        uint nextLevel = currentLevel+1 ;
        tokenRegistry[_tokenId].level = nextLevel;

        tokenRegistry[_tokenId].lastUpgradeTime = block.timestamp;

        uint randomNum = random();
        
        if(nextLevel == 1){
            _setTokenURI(_tokenId, level1[randomNum]);
            tokenRegistry[_tokenId].courseStatus = "Metaverse Intro";
            emit lastUpdated(_tokenId, block.timestamp, tokenRegistry[_tokenId].courseStatus);
            return;
        }

        if(nextLevel == 2){
            _setTokenURI(_tokenId, level2[randomNum]);
            tokenRegistry[_tokenId].courseStatus = "Blender 3D Modelling";
            emit lastUpdated(_tokenId, block.timestamp, tokenRegistry[_tokenId].courseStatus);
            return;
        }

        if(nextLevel == 3){
            _setTokenURI(_tokenId, level3[randomNum]);
            tokenRegistry[_tokenId].courseStatus = "VR Platform Use";
            emit lastUpdated(_tokenId, block.timestamp, tokenRegistry[_tokenId].courseStatus);
            return;
        }

        if(nextLevel == 4){
            _setTokenURI(_tokenId, level4[randomNum]);
            tokenRegistry[_tokenId].courseStatus = "Unity 3D Platform";
            emit lastUpdated(_tokenId, block.timestamp, tokenRegistry[_tokenId].courseStatus);
            return;
        }

        if(nextLevel == 5){
            _setTokenURI(_tokenId, level5[randomNum]);
            tokenRegistry[_tokenId].courseStatus = "Blockchain/NFTs";
            emit lastUpdated(_tokenId, block.timestamp, tokenRegistry[_tokenId].courseStatus);
            return;
        }
        // else {
        //     revert ("Final Level reached, can't upgrade.");
        // }
    }

    function checkLevel(uint _tokenId) public view returns(uint){
        uint currentLevel = tokenRegistry[_tokenId].level;
        return currentLevel;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721/*, ERC721Enumerable*/)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function getLatestId() public view returns(uint){
        uint256 latestTokenId = _tokenIdCounter.current();
        return latestTokenId;
    }

    function levelWiseNftSupply(uint _level)
       public view returns(uint[] memory nftList)
   {    
       uint256 latestTokenId = _tokenIdCounter.current();
       if (_level == 0){
          nftList = getNftList(_level, latestTokenId);
       }

       else if (_level == 1){
           nftList = getNftList(_level, latestTokenId);
       }

       else if (_level == 2){
           nftList = getNftList(_level, latestTokenId);
       }

       else if (_level == 3){
           nftList = getNftList(_level, latestTokenId);
       }

       else if (_level == 4){
           nftList = getNftList(_level, latestTokenId);
       }

       else if (_level == 5){
           nftList = getNftList(_level, latestTokenId);
       }
       return nftList;

   }

   function getNftList(uint _level, uint _latestTokenId) internal view returns(uint[] memory){
       uint[] memory nftList = new uint[](_latestTokenId);
           uint index = 0;
           for(uint s = 0 ; s < _latestTokenId ; s++ ){
               if (tokenRegistry[s].level == _level){

                   nftList[index] = tokenRegistry[s].id;
                   index++ ;
                //    console.log(index);
               }
           }
           return nftList;
   }

   function batchUpgrade(address[] calldata adressesList) public {
       for(uint s = 0; s <= adressesList.length ; s++) {
           (bool whiteListed,) = isWhitelisted(adressesList[s]);
           require(whiteListed, "address is not whitelisted to upgrade");
           uint id = getTokenDetails(adressesList[s]);
        //    uint courseLevel = tokenRegistry[s].level;
           upgradeNFT(id);

       } 
   }

   function getTokenDetails(address user) public view returns(uint){
       for(uint s = 0 ; s <= _tokenIdCounter.current(); s++){
           if(ownerOf(s) == user){
               return s;
           }
       }
   }

// Note:
// i. Assuming one address will hold one NFT Token ID only.
// ii. put bool readyForUpdate in struct. When it is true then only that id will upgrade. 
//         Once upgraded its status will get back to false and wait for trigger point to 
//         switch to True to get update.
// iii. batchUpgrade func is incomplete as of now as it will upgrade every whitelisted address
//       irrespective of their status to get upgraded.


}

//0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
//0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
//0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
//0x617F2E2fD72FD9D5503197092aC168c91465E7f2
//0x17F6AD8Ef982297579C203069C1DbfFE4348c372

// 4 - 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2

// ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db","0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB"]