# ceq


## CE prep

* `ibmcloud login ...`
* `ibmcloud target -r <region>`
* `ibmcloud target -g <rg>`
* `ibmcloud ce proj create --name ceq`
* `ibmcloud cr namespace-add utzb-ceq`
* `ibmcloud ce registry create --name ceq-cr`
* `ibmcloud ce build create --name job-build --source https://github.com/utzb/ceq --size small`

ibmcloud ce buildrun submit --build job-build --name job-build-run
