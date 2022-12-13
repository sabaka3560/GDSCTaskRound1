
pragma solidity 0.8.6;

/* token making problem gdsc requirements */
/* referred from etherium.org and coursera block specialisatins reference materials */

abstract contract ERC20GDSC {
    function name() virtual public view returns (string memory);
    function symbol() virtual public view returns (string memory);
    function decimals() virtual public view returns (uint8);
    function totalSupply() virtual public view returns (uint256);
    function balanceOf(address _owner) virtual public view returns (uint256 balance);
    function transfer(address _to, uint256 _value) virtual public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) virtual public returns (bool success);
    function approve(address _spender, uint256 _value) virtual public returns (bool success);
    function allowance(address _owner, address _spender) virtual public view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract Owned {
    address public owner;
    address public nextOwner;

    event transferOfOwnership(address indexed _from, address indexed _to);

    constructor() {
        owner = msg.sender;
    }

    function transferOwnership(address _to) public {
        require(msg.sender == owner);
        nextOwner = _to;
    }

    function ownershipTransferred() public {
        require(msg.sender == nextOwner);
        emit transferOfOwnership(owner, nextOwner);
        owner = nextOwner;
        nextOwner = address(0);
    }
}

contract Ricardo is ERC20GDSC, Owned {

    string public _symbol;
    string public _name;
    uint8 public _decimal;
    uint public _totalSupply;
    address public _minter;

    mapping(address => uint) balances;

    /* initialise */

    constructor () {
        _symbol = "RCD";
        _name = "Ricardo";
        _decimal = 0;
        _totalSupply = 1000000;
        _minter = 0xf05Db410E7211ADf9D16693BC054fb5cb9aB4d92;

        balances[_minter] = _totalSupply;
        emit Transfer(address(0), _minter, _totalSupply);
    }

    function name() public override view returns (string memory) {
        return _name;
    }

    function symbol() public override view returns (string memory) {
        return _symbol;
    }

    function decimals() public override view returns (uint8) {
        return _decimal;
    }

    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public override view returns (uint256 balance) {
        return balances[_owner];
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
        require(balances[_from] >= _value);
        balances[_from] -= _value; // balances[_from] = balances[_from] - _value
        balances[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function transfer(address _to, uint256 _value) public override returns (bool success) {
        return transferFrom(msg.sender, _to, _value);
    }

    function approve(address _spender, uint256 _value) public override returns (bool success) {
        return true;
    }

    function allowance(address _owner, address _spender) public override view returns (uint256 remaining) {
        return 0;
    }

}

