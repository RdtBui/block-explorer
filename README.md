# NEAR Block Explorer (Rails Take-Home Test)
This is a light weight block explorer built in Rails that fetches and displays recent `Transfer`-type transactions.

## Features
- Root index page displaying:
  - Sender
  - Receiver
  - Deposit
- Historal transactions persist locally even if they disappear from the API
- Sync transactions with the mock API by clicking on the "Fetch New Transactions" button

### Built With
- Ruby `3.2.6`
- Rails `7.1.3`
- SQLite

### Game Plan
The thought process tackling this challenge was to focus on the requirements:
1. A root index page with a list of transfers with the following fields: sender, receiver and deposit.
2. The app should show the historical transactions it was able to fetch already even if they are no longer returned by the API.

My goal was to create an MVP with all the requirements and expectations met. See [What I'd Improve With More Time](#what-id-improve-with-more-time) for what could've been added given more time.

### Total Time Taken
3h03m with ~2 hours spent on building the project and 1 hour for the README. The extra 3 minutes were spent to complete the README.

---

## Getting Started
```bash
git clone https://github.com/RdtBui/block-explorer.git
cd near-block-explorer
bundle install
rails server
```

Then head to `http://localhost:3000` and you should see the transactions table. Click on the `Fetch New Transactions` button to simulate an API sync with the mock API provided.

Rails should populate the empty table:
![image](https://github.com/user-attachments/assets/2c6b9777-8327-4bf3-a3e0-63905724539e)


## Domain Modeling
### Model
Transaction
* `time`
* `height`
* `tx_hash`, unique and indexed to speed up the querying process
* `block_hash`, unique and indexed
* `sender`
* `receiver`
* `gas_burnt`
* `deposit`
* `success`

## How Syncing Works
* A service object `NearTransactionImporter` fetches the API through calling the `import` action from the `TransactionController`. In this case, it only fetches from the mock endpoint but it should equally work with a real API given the formats are similar.
* It filters out Transactions with non-Transfer actions.
* It stores a transaction along with the `deposit` attribute from `actions` only if the transaction is new. The `tx_hash` is used as a natural key to uniquely verify if a transaction already exists in the database to prevent duplicate entries.
  * `tx_hash`, which is the transaction `hash`, is named so due to name collision with Rails' `hash` method.

## Trade-offs and Assumptions
* The `Transaction` model was designed with simplicity in mind. However, given more time, I would have taken a different approach to make it more robust and scalable. I would introduce separate `Transaction` and `Action` tables, where each `Transaction` would have many associated `Actions` through a foreign key relationship. The benefits of implementing seperate table would allow better data integrity and easier queries which goes outside of the requirements' scope.
* Transaction hash and block hash is unique. The block height is most likely unique as well but it's not reflected in the project.
* Most of the data attributes given by the API endpoint were saved but we only cared about the `sender`, `receiver`, and the `deposit` amount. The rest could've been ignored. That would've saved us some storage. The choice to include most of the attributes was because it's fairly simple to add the columns at the start and it would be easier to scale later.
* `gas_burnt` was stored as a `bigint` with the assumption that it won't be too big of a number.

## What I'd Improve With More Time
* Add tests for sure.
* Turn the API sync into a background job instead of refreshing with the click of a button.
* Have a `Transaction` and `Action` table/model.
* Implement the logic to process Transactions with multiple Actions.
* Format `deposit` into a human-readable NEAR amount.
* Add more relevant comments throughout the project.
* Add pagination to the list of transactions.
* Better UI.
