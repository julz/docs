# Deploying your first Knative Service

==**In this tutorial, we are going to use [KonK](https://konk.dev) to deploy a "Hello world" Service!**== This service will accept an environment variable, `TARGET`, and print "`Hello $TARGET`."

For those of you familiar with other **source-to-url** tools, this may seem familiar. However, since our "Hello world" Service is being deployed as a Knative Service, it gets some **super powers (scale-to-zero, traffic-splitting) out of the box** :rocket:.

## Deploying your first Knative Service: "Hello world!"
=== "kn"

    ``` bash
    kn service create hello \
    --image gcr.io/knative-samples/helloworld-go \
    --port 8080 \
    --env TARGET=World \
    --revision-name=world
    ```

=== "YAML"

    ``` bash
    apiVersion: serving.knative.dev/v1
    kind: Service
    metadata:
      name: hello
    spec:
      template:
        metadata:
          name: world
        spec:
          containers:
            - image: gcr.io/knative-samples/helloworld-go
              ports:
                - containerPort: 8080
              env:
                - name: TARGET
                  value: "World"
    ```
    Once you've created your YAML file (named something like "hello.yaml"):
    ``` bash
    kubectl apply -f hello.yaml
    ```

### Expected Output
After Knative has successfully created your service, you should see the following:
```bash{ .bash .no-copy }
Service hello created to latest revision 'hello-world' is available at URL: http://hello.default.127.0.0.1.nip.io
```

Note that the name "world" which you passed in as "revision-name" is being used to create the `Revision`'s name "hello-world" (we'll talk more about `Revisions` later).

### Testing your deployment

```
curl http://hello.default.127.0.0.1.nip.io
```

**The output should be:**
```{ .bash .no-copy }
Hello World!
```

Congratulations :tada:, you've just created your first Knative Service!
