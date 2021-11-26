pragma ton-solidity >= 0.43.0;

pragma AbiHeader expire;
pragma AbiHeader time;

import "./ERC721Enumerable.sol";

contract NFTColection is ERC721Enumerable {

    struct mintSetings {
        uint256 maxSupply;
        bool paused;
        bool isMintUser;
        uint256 commissionAmount; //храниться в nTon
        uint256 amountAttributes;
    }

    struct metadataToken {
        string name;
        string description;
        string image;
        string dna;
        string data;
    }

    struct attribute {
        string _type;
        string value;
        uint8 rare;
    }


    address authorColection;
    address ownerColection;

    mintSetings private _mintSetings;

    mapping(uint256 => metadataToken) private _metadataTokens;

    mapping(uint256 => attribute[]) private _attributesTokens;

    constructor(string name, string symbol, mintSetings setings, address author, address owner) ERC721Enumerable(name, symbol) public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        _mintSetings = setings;
        authorColection = author;
        ownerColection = owner;
    }

    function mint(metadataToken metadata, attribute[] attributes) public {
        mintSetings setings = _mintSetings;
        require(!setings.paused);
        uint256 supply = totalSupply();
        if(setings.amountAttributes != 0) {
            require(attributes.length == setings.amountAttributes);
        }

        if(setings.maxSupply != 0) {
            require(supply + 1 <= setings.maxSupply);
        }

        if(!setings.isMintUser) {
            require(msg.sender == ownerColection);
        }
        
        if(msg.sender != ownerColection) {
            require(msg.value >= setings.commissionAmount);
        }

        _metadataTokens[supply + 1] = metadata;
        _attributesTokens[supply + 1] = attributes;
        _mint(msg.sender, supply + 1);
    }

    function getMetadata(uint256 tokenId) public view returns(metadataToken) {
        require(_exists(tokenId));
        return _metadataTokens[tokenId];
    }

    function getAttributes(uint256 tokenId) public view returns(attribute[]) {
        require(_exists(tokenId));
        return _attributesTokens[tokenId];
    }


}