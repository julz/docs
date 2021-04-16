## Background
In the previous step, we talked a bit about CloudEvents and their role in Knative, specifically their ability to transport bits of information within our Knative deployment. If one of your Knative Services produces a CloudEvent, how can you ensure that it arrives at its destination?

That's where `Brokers` come in. `Brokers` are a fault-tolerant way to intake CloudEvents from `Sources` (which emit CloudEvents) and send them to the correct `Sink` (which consume CloudEvents).

But a `Broker` can't do this work alone, `Triggers` help to filter the CloudEvents to the correct place but more on that later.

## Examining the Broker
As part of the `KonK` install, you should have an in-memory `Broker` already installed.
```bash
    kn broker list
```

You should get:
```bash
NAME      URL                                                                        AGE   CONDITIONS   READY   REASON
default   <broker-url>                                                               5m    5 OK / 5     True    
```
Where `<broker-url>` is the location of the `Broker`.
!!! warning
    In-Memory Brokers are for development use only and must not be used in a production deployment.
