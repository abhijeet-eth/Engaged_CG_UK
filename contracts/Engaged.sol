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
        uint level;
        uint lastUpgradeTime;
    }

    TokenDetails public tokenDetails;

    address[] public whitelistAddresses;

    mapping(address => bool) public whitelist;
    mapping(uint => TokenDetails) public tokenRegistry;
    
    event Attest(address indexed to, uint256 indexed tokenId);
    event Revoke(address indexed to, uint256 indexed tokenId);

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
        tokenRegistry[tokenId].level = 0;
        tokenRegistry[tokenId].lastUpgradeTime = block.timestamp;

        uint randomNum = random();

        _safeMint(to, tokenId);
        _setTokenURI(tokenId, level0[randomNum]);

        addToWhitelist(to);
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

    function upgradeNFT(uint _tokenId) public {
        require(msg.sender == ownerOf(_tokenId), "Not owner");
        require(block.timestamp > tokenRegistry[_tokenId].lastUpgradeTime + 10,"Cooling time, Can't upgrade now");
        require(tokenRegistry[_tokenId].level <= 6, "Highest level reached, no upgrades available !!");

        uint currentLevel = tokenRegistry[_tokenId].level;
        uint nextLevel = currentLevel+1 ;
        tokenRegistry[_tokenId].level = nextLevel;

        tokenRegistry[_tokenId].lastUpgradeTime = block.timestamp;

        uint randomNum = random();
        
        if(nextLevel == 1){
            _setTokenURI(_tokenId, level1[randomNum]);
        }

        if(nextLevel == 2){
            _setTokenURI(_tokenId, level2[randomNum]);
        }

        if(nextLevel == 3){
            _setTokenURI(_tokenId, level3[randomNum]);
        }

        if(nextLevel == 4){
            _setTokenURI(_tokenId, level4[randomNum]);
        }

        if(nextLevel == 5){
            _setTokenURI(_tokenId, level5[randomNum]);
        }

        if(nextLevel == 6){
            _setTokenURI(_tokenId, level6[randomNum]);
        }

        if(nextLevel == 7){
            _setTokenURI(_tokenId, GODLevel);
        }
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



}

