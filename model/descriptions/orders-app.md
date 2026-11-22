# Orders App

The Orders App owns the lifecycle of a customer order from the moment it is placed
until it is delivered. It exposes a JSON over HTTPS API for the storefront and emits
domain events that downstream systems (billing, fulfilment, analytics) subscribe to.

## Key flows

- **Place order** — validates the cart, reserves stock, and triggers payment.
- **Pay order** — calls the payment gateway, updates state to `paid`.
- **Ship order** — once fulfilment confirms, marks the order `shipped` and notifies the customer.

## Data ownership

The Orders App is the source of truth for the **order** aggregate. Any other system
that needs order data subscribes to the `orders.*` event stream.
