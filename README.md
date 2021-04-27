# KPN Assigment

This is the repository of the development built by *Jeferson Ruiz*.
## Pre steps:

1. Because Salesforce at the present does not allow add Custom Labels to packages, if you decide to use the package link, we recommend deploy the custom labels metadata in this repository to your Org.

2. The test endpoint generated in **requestcatcher** is:

        https://orderconfirmation.requestcatcher.com/

    Add this url to the authorized sites in the **Remote Site Settings** in your org.

## Deploy the functionality:

#### 1. Via package link:

https://login.salesforce.com/packaging/installPackage.apexp?p0=04t1U000007kMq3


#### 2. From this repository:

The full functionality code is located in the branch named <code>feature-KPN-orderLWC</code>. The <code>main</code> remains as a new SFDX project. This is useful to deploy via git differences and [SF power kit](https://github.com/Accenture/sfpowerkit), if you don't prefer the package link; just install the SF power kit, clone this SFDX project, connect it to your Org, and execute this commands:

        $ sfdx sfpowerkit:project:diff -d ./delta --revisionfrom=main --revisionto=feature-KPN-orderLWC
        $ sfdx force:source:deploy -p ./delta/force-app/main/default/ --verbose

Or even easier, just deploy the full <code>force-app</code> from the <code>feature-KPN-orderLWC</code> branch (jeje).

## Preview

Here a video link to a brief preview of the final functionality.

(PENDING)
