# Seek

We are interested in seeing your coding and problem solving style, so we would love if
you could complete this open code test.
For the purpose of this exercise, SEEK is in the process of rewriting its job ads checkout system. You have been assigned to build this new system.

We want to offer different products to recruiters:

1. Classic Ad : Offers the most basic level of advertisement
2. Standout Ad : Allows advertisers to use a company logo and use a longer presentation text
3. Premium Ad : Same benefits as Standout Ad, but also puts the advertisement at the top of the results, allowing higher visibility

Each of the product is billed as follows:

| ID       | Name        | Price   |
| -------- | ----------- | ------- |
| classic  | Classic Ad  | $269.99 |
| standout | Standout Ad | $322.99 |
| premium  | Premium Ad  | $394.99 |

We established a number of special pricing rules for a small number of privileged customers:

1. UNILEVER
  - Gets a 3 for 2 deals on Classic Ads

2. APPLE
  - Gets a discount on Standout Ads where the price drops to $299.99 per ad

3. NIKE
  - Gets a discount on Premium Ads where 4 or more are purchased. The price drops to $379.99 per ad

4. FORD
  - Gets a 5 for 4 deal on Classic Ads
  - Gets a discount on Standout Ads where the price drops to $309.99 per ad
  - Gets a discount on Premium Ads when 3 or more are purchased. The price drops to $389.99 per ad

These details are regularly renegotiated, so we want the pricing rules to be as flexible as
possible as they can change in the future with little notice.

The interface to our checkout looks like this (shown in Ruby-ish pseudocode):

```elixir
  checkout = Checkout.new(pricing_rules: pricing_rules)
  checkout = Checkout.add_item(checkout, classic)
  checkout = Checkout.add_item(checkout, standout)
  checkout = Checkout.add_item(checkout, premium)
  checkout = Checkout.calculate_total(checkout)

  checkout.total
```

Your task is to implement a checkout system that fulfils the requirements described above.

Example scenarios:

```
Customer: default
Items added: ["classic", "standout", "premium"]
Total expected: $987.97

Customer: Unilever
Items added: ["classic", "classic", "classic", "premium"]
Total expected: $934.97

Customer: Apple
Items added: ["standout", "standout", "standout", "premium"]
Total expected: $1294.96

Customer: Nike
Items added: ["premium", "premium", "premium", "premium"]
Total expected: $1519.96

Customer: Ford
Items added: ["classic", "classic", "classic", "classic", "classic", "standout", "premium", "premium", "premium"]
Total expected: $2559.92
```


