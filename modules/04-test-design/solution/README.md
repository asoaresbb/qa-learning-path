# Solution — test design for an order flow

There is no single right answer. This is *one* defensible set of decisions, to compare your reasoning against.

## 1. Testing notes (what exploring surfaced)

Things you only notice by walking it, not by reading a spec:

- What happens to the cart if I change quantity to 0? To 999? To a negative number via the URL?
- If payment fails, is the order created anyway? Is the cart preserved?
- Back button after confirmation — does it place a second order?
- Two tabs, same account — does the stock count go negative?
- Currency/rounding on the total when there's a discount.

Each of these updates the mental model and becomes a candidate check. None were obvious before exploring.

## 2. Check design

**One end-to-end test or one per step?** Both, at different levels — this is the test pyramid:

- **One** end-to-end check for the happy path: add → checkout → pay → confirm. It proves the pieces connect. It's slow and expensive, so you want very few of these.
- **Many** cheaper checks for the inputs, against the API or units directly, not through the browser. This is where partitioning and boundaries live.

**Partitions and boundaries for the inputs:**

| Input | Partitions | Boundary cases |
|-------|-----------|----------------|
| Quantity | below min, valid, above stock, non-numeric | 0 / 1, stock / stock+1 |
| Address postcode | valid format, wrong format, empty | min/max length |
| Payment amount | matches total, mismatched, zero | total ± smallest unit |

**What to keep:** the single E2E happy path, plus API-level checks for each partition above and for the abuse cases that carry real risk (quantity 0, payment-fail-but-order-created). Drop checks that are slow, flaky, or guard something low-risk (footer text). Confidence per unit of upkeep is the criterion.

## 3. Intent vs mechanics for one step

**Intent:** *the customer pays and the order is confirmed.*

**Mechanics that step needs:**
- fill card fields / POST to `/checkout` with a payment token
- wait for the payment provider's response
- assert redirect to a confirmation page / `201` with an order id
- assert an order row now exists with status `confirmed`

The intent is one sentence and stable. The mechanics are many and will change when the UI or payment provider does. Module 11's Page Object Model is exactly the tool that keeps the first sentence and hides the list beneath it.
