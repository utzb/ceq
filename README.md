# ceq


## CE prep

* `ibmcloud login ...`
* `ibmcloud target -r <region>`
* `ibmcloud target -g <rg>`
* `ibmcloud ce proj create --name ceq`
* note: QR doesn't support service credentials. So we cannot use binding them, but have to use a secret. Use environment variables QISKIT_CRN and QISKIT_TOKEN in your code.
* `ibmcloud ce secret create --name ceq-secret --from-literal QISKIT_CRN=my-crn --from-literal QISKIT_TOKEN=my-token`

## Quick build -- stores into a private CE registry
* `ibmcloud ce job create --name ceq-job --build-source https://github.com/utzb/ceq`
* `ibmcloud ce jobrun submit --env-from-secret ceq-secret --job ceq-job --name ceq-jobrun`
  * `ibmcloud ce jobrun get --name ceq-jobrun`
  * `ibmcloud ce jobrun logs -f --name ceq-jobrun`

## Build image yourself in defined image location
* `ibmcloud cr region-set us-south`
* `ibmcloud cr namespace-add ceq-cr`
* `ibmcloud ce build create --name ceq-build --source https://github.com/utzb/ceq --image private.us.icr.io/ceq-cr/ceq-build`
* `ibmcloud ce buildrun submit --build ceq-build --name ceq-buildrun`
  * `ibmcloud ce buildrun get --name ceq-buildrun`
  * `ibmcloud ce buildrun logs -f --name ceq-buildrun`
* optional: `ibmcloud cr va ceq-cr/ceq-build`
  * `for i in $(ibmcloud cr va ceq-cr/ceq-build --output json | jq '.[].vulnerabilities[].cve_id'); do ic cr exemption-add --scope ceq-cr/ceq-build --issue-type cve --issue-id $(echo $i | tr '"' ' ') ; done`
  * `for i in $(ibmcloud cr va ceq-cr/ceq-build --output json| jq '.[].configuration_issues[].type'); do ic cr exemption-add --scope ceq-cr/ceq-build --issue-type configuration --issue-id $(echo $i | tr '"' ' ') ; done`
* `ibmcloud ce jobrun submit --name ceq-jobrun --env-from-secret ceq-secret --image private.us.icr.io/ceq-cr/ceq-build --registry-secret ce-auto-icr-private-us-south`
  * `ibmcloud ce jobrun get --name ceq-jobrun`
  * `ibmcloud ce jobrun logs -f --name ceq-jobrun`

