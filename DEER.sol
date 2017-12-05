pragma solidity ^0.4.11;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';

contract DEER is MintableToken {
    string public constant name = "DEER";
    string public constant symbol = "DEER";
    uint8 public constant decimals = 18;

    uint256 public adoptionTime = 1 days;

    address public stable;

    uint256 public updateTimestamp;

    function DEER(address[] accounts, uint256 amount) {
        for(uint256 i = 0; i < accounts.length; i++) {
            mint(accounts[i], amount);
        }

        changeStable(msg.sender);

        finishMinting();
    }

    function changeStable(address value) internal {
        stable = value;
        updateTimestamp = now;
    }

    function transfer(address _to, uint256 _value) returns (bool) {
        if(balances[_to].add(_value) > balances[stable]) {
            changeStable(_to);
        }

        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
        if(balances[_to].add(_value) > balances[stable]) {
            changeStable(_to);
        }

        return super.transferFrom(_from, _to, _value);
    }

    function claimReward() public {
        require(stable == msg.sender);
        require(updateTimestamp + adoptionTime <= now);

        uint256 reward = now - adoptionTime - updateTimestamp;

        updateTimestamp = now;

        balances[msg.sender] = balances[msg.sender].add(reward * 1e18);
    }
}