// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
//import another contract to convert ETH to USD
import { PriceConverter } from "./PriceConverter.sol";
contract Contract {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 1e18;
    uint256 public projectNumber = 0;

    // how projects are intended to be stored
    struct Project {
        string projectName;
        string projectDetail;
        address projectOwner;
        uint256 contributorCount;
    }

    Project[] public listOfProject;

    mapping(uint256 => string) public projectNumberToProjectName;
    mapping(uint256 => address) public projectNumberToProjectOwnerAddress;
    mapping(uint256 => uint256) public projectNumberToNumberOfContributors;

    // user can create project to get funded
    function createNewProject(
        string memory nameOfProject,
        string memory details,
        address projectCreator,
        uint256 numberOfContributors
    ) public {
        listOfProject.push(
            Project(
                nameOfProject,
                details,
                projectCreator,
                numberOfContributors
            )
        );
        projectNumber += 1;
        projectNumberToProjectName[projectNumber] = nameOfProject;
        projectNumberToProjectOwnerAddress[projectNumber] = projectCreator;
        projectNumberToNumberOfContributors[
            projectNumber
        ] = numberOfContributors;
    }

    mapping(address => uint256) public addressToAmount;

    // other users can contribute a minimum of 1USD to any project of their choice
    function contributeToProject(uint256 index) public payable{
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough ETH");
        addressToAmount[msg.sender] = msg.value;
        uint256 project_number = index - 1;
        Project storage project = listOfProject[project_number];
		project.contributorCount += 1;
    }

    // just a function to check how much value does the contract stores
    function getTotalValueStoredInContract() public view returns(uint256){
        return address(this).balance;
    }
}
