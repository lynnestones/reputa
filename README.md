# Reputa

A decentralized, on-chain reputation network for professionals, freelancers, and contributors across the Web3 ecosystem. Reputa provides verifiable identity, trust scores, credentials, and peer feedback using smart contracts written in Clarity.

---

## **Overview**

This system consists of ten modular smart contracts that collectively manage reputation, credential verification, dispute resolution, and staking logic:

1. **Reputation Score Contract** – Calculates and maintains dynamic reputation scores
2. **Profile NFT Contract** – Issues non-transferable identity NFTs to users
3. **Credential Issuance Contract** – Allows institutions to mint verifiable credentials
4. **Job Task Contract** – Manages job postings, payments, and completion verification
5. **Review & Endorsement Contract** – Collects feedback and peer endorsements
6. **Dispute Resolution Contract** – Facilitates arbitration and resolution processes
7. **Staking & Slashing Contract** – Enforces accountability through staking
8. **Reputation Oracle Contract** – Enables external access to on-chain reputation data
9. **Governance Contract** – Manages system rules through DAO voting
10. **Rewards Contract** – Issues incentives for ecosystem contributors

---

## **Features**

- Decentralized identity and non-transferable profile NFTs  
- Verifiable, tamper-proof reputation scores  
- Transparent feedback and endorsement mechanisms  
- Dispute resolution with community-based arbitration  
- Credential issuance by authorized organizations  
- Token staking for accountability  
- DAO-based governance and upgrades  
- Cross-platform reputation portability via oracles  
- On-chain incentives for validators and reviewers  

---

## **Smart Contracts**

### **Reputation Score Contract**
- Score updates based on task history, feedback, disputes, and staking
- Weighting of feedback over time
- Sybil-resistance mechanisms

### **Profile NFT Contract**
- Issues soulbound identity NFTs (non-transferable)
- Links to user data, reputation, and credentials

### **Credential Issuance Contract**
- Institutions mint credentials (ERC-721 or SBT-style)
- Verified through whitelisted issuers
- Timestamped and linked to user profiles

### **Job Task Contract**
- Allows job/task creation, funding, and dispute hooks
- Links task outcomes to user reputation

### **Review & Endorsement Contract**
- Enables structured reviews after tasks
- Peer-to-peer endorsement system
- Reviewers must stake tokens to prevent spam

### **Dispute Resolution Contract**
- Uses decentralized juries to resolve conflicts
- Verdicts affect reputation and trigger staking consequences

### **Staking & Slashing Contract**
- Freelancers and clients stake tokens as escrow
- Misbehavior results in slashing and reputation penalties

### **Reputation Oracle Contract**
- External dApps and DAOs can query scores via API endpoints
- Access control and data-rate limiting

### **Governance Contract**
- Manages protocol rules, scoring logic, credential whitelists
- Token or reputation-weighted DAO voting

### **Rewards Contract**
- Issues platform tokens for validated contributions
- Bounties for dispute resolution and DAO participation

---

## **Installation**

1. Install Clarinet CLI:  
   ```bash
   npm install -g @hirosystems/clarinet
   ```
2. Clone this repository:
    ```bash
    git clone https://github.com/yourusername/reputa.git
    ```
3. Run tests:
    ```bash
    npm test
    ```
4. Deploy contracts:
    ```bash
    clarinet deploy
    ```

## **Usage**

Each smart contract is modular and can be deployed independently. Refer to the /contracts directory for contract-specific instructions, arguments, and test examples.

To integrate reputation queries or credentials into your own dApp, use the Oracle Contract and Profile NFT standard as an interface.

## **Testing**

Unit tests are written in Vitest and can be executed with:
    ```bash
    npm test
    ```
To run individual contract tests or simulate blockchain state transitions, use Clarinet's integrated testing tools.

## **License**

MIT License
