# KPN Assigment

This is the repository of the development built by *Jeferson Ruiz*.

## Description

This functionality allows to see the associated products of the pricebook associated to an Order in Salesforce. It's consist of two Lighting Web Components, the first one to list the Available Products from the Pricebook, and the second one to list the products than have been added to the order. They interact each other through **LWC Message Service** and the **uiRecordApi**, allowing update in real time order products quantity, and avoiding add new products, when the order is activated.
## Pre steps:

Before installing this functionality in your Salesforce Org, we recommend to follow this preview steps:

1. Because Salesforce at the present does not allow add Custom Labels to packages, if you decide to use the package method to implemente this functionality, please deploy the custom labels metadata in this repository to your Org. Probably this step shouldn't be necessary, but it can avoid issues in the messages sent to the final users.
<br/>
2. The external confirmation system is called via this endpoint generated in **requestcatcher**:

        https://orderconfirmation.requestcatcher.com/

   To allow the activation of orders, add this url to the authorized sites in the **Remote Site Settings** in your org.

## Deploy the functionality

There are two ways to implement this functionality in your org.
#### 1. Via package link:

This functionality is available by a Salesforce package. If you want to implement it in a Developer or Productive org, just follow this link:

https://login.salesforce.com/packaging/installPackage.apexp?p0=04t1U000007kMq3

if you want to implement the functionality in a sandbox, follow this linK:

https://test.salesforce.com/packaging/installPackage.apexp?p0=04t1U000007kMq3

Just follow the steps in the page.

#### 2. From this repository:

The full functionality code is located in the branch named <code>feature-KPN-orderLWC</code>. The <code>main</code> remains as a new SFDX project.

If you prefer this method to deploy this functionality, the easier way to do it is creating a new SFDX project locally, connecting it to the desired Org, and deploy the full content fo the folder <code>force-app</code>, executing this SFDX command:

        $ sfdx force:source:deploy -p ./force-app/main/default/ --verbose

Another way, if you prefer use the git diffs, is generate a folder with the modified metadata and deploy it. You will need install the [sfpowerkit](https://github.com/Accenture/sfpowerkit) plugin to Salesforce DX. Just follow the instructions to do it.

Once you have installed the plugin, clone this repo locally and run the following commands:

        $ sfdx sfpowerkit:project:diff -d ./delta --revisionfrom=main --revisionto=feature-KPN-orderLWC
        $ sfdx force:source:deploy -p ./delta/force-app/main/default/ --verbose

## Preview

### Sortable Columns!
![image](https://i.imgur.com/bMD6c5Q.gif)
### Automatic Order Products Quantity Update!
![image](https://i.imgur.com/HcUrHfs.gif)
### Activated Orders And Disabling Add New Products!
![image](https://i.imgur.com/VFTroRz.gif)