// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

contract Hospital{
    //this hospital controling owner;
    address owner;
    
    
    constructor(){
        owner = msg.sender;
    }
    
    //Hostpital in patientType;

    enum patientType {
        Donor,
        Receiver
    }
    
    //here storing bloodTransaction record;

    struct bloodTransaction{
        patientType PatientType;
        uint256 timestamping;
        address from;
        address to;
    }
    

    //here store patientRegistration details;

    struct patientRegistration{
        string name;
        uint256 age;
        string location;
        uint256 contractNumber;
        uint256 nidNumber;
        string parmanentAddress;
        bloodTransaction[] bT;
    }

    // Array sotre that patinetregistration records all deatials and all patientRecords fetch all data;
     patientRegistration[] patientRecord;
    
    // map is used to map the addhar card with the index number of the array where patient record is stored
    // this will prevent the use of loop in contract

    mapping(uint256 => uint256) PatientRecordIndex;
    //used notiifing that function exucet yes or not;
    event Successfull(string message);

    //newPatientRegistration here;
    
    function newPatientRegistration(
        string memory newNmae,
        uint256 newAge,
        string memory newLoction,
        uint256 newContractNumber,
        uint256 newNidNumber,
        string memory newParmanentAddress
    ) external {
        // here check new patient registration complete this massage sender passed going that check 
        require(msg.sender == owner,"only owneer can register new patient");
        
        //get patientRecords array length;
        uint256 index = patientRecord.length;

        //here insert the patinet record deatiels;
        patientRecord.push();
        patientRecord[index].name = newNmae;
        patientRecord[index].age = newAge;
        patientRecord[index].location = newLoction;
        patientRecord[index].contractNumber = newContractNumber;
        patientRecord[index].nidNumber = newNidNumber;
        patientRecord[index].parmanentAddress = newParmanentAddress;

        // store the aaray index in the map against the user addhar number
        
        PatientRecordIndex[newNidNumber] = index;
        emit Successfull("newPatient added successfully");
    }

    //function get user of specific  data;

        function getPatientRecord(uint256 newNidNumber) external view returns(patientRegistration memory){
            uint index = PatientRecordIndex[newNidNumber];
            return patientRecord[index];
    }

    // get the patient record all data

    function getAllPatientRecord() external view returns(patientRegistration[] memory){
        return patientRecord;
    }

    //store the blocdtransaction all data;
    function bloodTransactionAllData(
    uint256 newNidNumber,
    patientType _Type,
    address _from,
    address _to
    ) external {
         require(msg.sender == owner,"only oner can update this data");
         uint256 index = PatientRecordIndex[newNidNumber];

         //insert the bloodtransaction all data 

         bloodTransaction memory tnx = bloodTransaction({
             PatientType: _Type,
             timestamping: block.timestamp,
             from: _from,
             to: _to
         });

        patientRecord[index].bT.push(tnx);

        
        // PatientRecord[index].bT.push(BloodTransaction(_type, block.timestamp,_from,_to));
        emit Successfull("new patient update data succesfully");



    }

    

  














}