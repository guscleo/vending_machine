# VendingMachine

Design a vending machine using ruby. The vending machine should perform as follows:

* Once an item is selected and the appropriate amount of money is inserted, the vending machine should return the correct product.
* It should also return change if too much money is provided, or ask for more money if insufficient funds have been inserted.
* The machine should take an initial load of products and change. The change will be of denominations 1p, 2p, 5p, 10p, 20p, 50p, £1, £2.
* There should be a way of reloading either products or change at a later point.
* The machine should keep track of the products and change that it contains.

## Requirements analysis (draft / just comments)

> Once an item is selected and the appropriate amount of money is inserted, the vending machine should return the correct product.

Select product -> insert coins and keep the record of money inserted (validate if coin is valid, validate if price of the product is reached)

> It should also return change if too much money is provided, or ask for more money if insufficient funds have been inserted.

Once product price is reached, discount product price from money inserted

> The machine should take an initial load of products and change. The change will be of denominations 1p, 2p, 5p, 10p, 20p, 50p, £1, £2.

No need to store name of products, we only need to keep vending machine’s state of products [item_code, qty] and coins [coin_type, qty]
Given we’re actually considering coin types, we might not be able to return change to the customer if we don’t have coins.
If the machine has £10.000 balance, but only £2 coins, it’s difficult to return change for £0.50 product.
Taking a pragmatic approach, consider telling the customer that we don’t have change for the product he wants, ask if he would like to proceed.

> There should be a way of reloading either products or change at a later point.

Shouldn’t be too difficult to re-use above services

> The machine should keep track of the products and change that it contains.

Idea: If the customer added coins, should we consider those coins to give the best change?

## Technical decisions (before implementation)

The exercise asks to design a vending machine using ruby. From the requirements above, I am able to define the interface for a vending machine, there are two things I need to decide:

* How to keep context.

    1. Inserting a coin now and a coin in 10 minutes might be a complete different session, or could be the same one. Given the requirements say “Once an item is selected”, a session will start once an item is selected, and will finish either by reaching the item’s price, or by cancelling the current session.
    2. For the purpose of this exercise, I am considering out of scope race conditions, like 2 customers trying to use the same vending machine at the same time. I am planning to keep the context of two different sessions separated, just not planning to deal with 2 sessions trying to access the same resources.

* How to interact with this vending machine. I will leave a potential UI as out of scope, the tests should provide a clear idea about how we can use the vending machine, and I am happy to come back to this and build a UI if it was something you were looking forward to see me doing.

## Conclusions (after implementation)

I have built:
* A vending machine object, that keeps the state of its products & coins stocks
* A Coins module, that has coin types and their values
* A session, that can be created "within" a vending machine. It keeps its status and allows users to select a product and insert coins. Based on each action, it recalculates its state and whether it should return the product or not, and change.
* A change calculator, that calculates how much coins of each type it returns based on a given change amount to return and the current coin stock.
* A small script `app.rb` to play with the code.

Perhaps you were looking more for a JSON API implementation, or an implementation backed by ActiveRecord tables, etc. Given the test is open to interpretation, I had to do some assumptions/decisions on how to accomplish the acceptance criteria. But if there is something else in particular you would like to test my skills on, I am more than happy to do it.
