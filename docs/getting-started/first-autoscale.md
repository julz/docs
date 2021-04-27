# Scaling to Zero
**Remember those super powers :rocket: we talked about?** One of Knative Serving's powers is automatic scaling or simply "autoscaling" out-of-the-box! This means your Knative Service will only "spin up" to preform its job (in this case, saying "Hello world!") if it is needed, otherwise, it will =="scale to zero"== by spinning down and waiting for a new request to come in.

??? question "What about scaling up to meet increased demand?"
    Knative Autoscaling also allows you to easily configure your service to scale up (horizontal autoscaling) to meet increased demand as well as control the number of instances which spin up using <a href= "../../serving/autoscaling/concurrency/" target="_blank"> "concurrency limits,"</a> but that's beyond the scope of this tutorial.

**Let's see this in action!** We're going to peek under the hood at the <a href= "https://kubernetes.io/docs/concepts/workloads/pods/" target="blank_">Pod</a> in Kubernetes where our Knative Service is running to watch our "Hello world!" Service scale up and down.


### Check the Knative Pods
Let's run our "Hello world!" Service just one more time.
```bash
curl http://hello.default.127.0.0.1.nip.io
```

You can watch the pods and see how they ==scale to zero== after traffic stops going to the URL.
```bash
kubectl get pod -l serving.knative.dev/service=hello -w
```

### Expected Output
```{ .bash .no-copy }
NAME                                     READY   STATUS
hello-world                              2/2     Running
hello-world                              2/2     Terminating
hello-world                              1/2     Terminating
hello-world                              0/2     Terminating
```

Try to access the url again, and you will see a new pod running again.
```{ .bash .no-copy }
NAME                                     READY   STATUS
hello-world                              0/2     Pending
hello-world                              0/2     ContainerCreating
hello-world                              1/2     Running
hello-world                              2/2     Running
```

Some people call this **Serverless** :tada: :taco: :fire:

??? question "Want to go deeper on Autoscaling?"
    Interested in getting in the weeds with Knative Autoscaling? Check out the <a href= "../../serving/autoscaling/" target="_blank"> autoscaling page</a> for concepts, samples, and more!
