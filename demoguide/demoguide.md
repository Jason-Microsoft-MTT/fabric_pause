[comment]: <> (please keep all comment items at the top of the markdown file)
[comment]: <> (please do not change the ***, as well as <div> placeholders for Note and Tip layout)
[comment]: <> (please keep the ### 1. and 2. titles as is for consistency across all demoguides)
[comment]: <> (section 1 provides a bullet list of resources + clarifying screenshots of the key resources details)
[comment]: <> (section 2 provides summarized step-by-step instructions on what to demo)


[comment]: <> (this is the section for the Note: item; please do not make any changes here)
***
### Microsoft Fabric Capacity with Auto-Pause Logic App

<div style="background: lightgreen; 
            font-size: 14px; 
            color: black;
            padding: 5px; 
            border: 1px solid lightgray; 
            margin: 5px;">

**Note:** Below demo steps should be used **as a guideline** for doing your own demos. Please consider contributing to add additional demo steps.
</div>

[comment]: <> (this is the section for the Tip: item; consider adding a Tip, or remove the section between <div> and </div> if there is no tip)

***
### 1. What Resources are getting deployed
<add a one-paragraph lengthy description of what the scenario is about, and what is getting deployed>

Provide a bullet list of the Resource Group and all deployed resources with name and brief functionality within the scenario. 

* rg-%azdenvironmentname - Azure Resource Group.
* Fabric%uniquestring% - Microsoft Fabric Capacity (F8 SKU)
* LogicApp-Pause-Fabric - Azure LogicApp to pause the Fabric Capacity (to save cost; runs every 4 hours UTC)

<img src="https://raw.githubusercontent.com/petender/issdata/refs/heads/main/demoguide/ResourceGroup_Overview.png" alt="ISS Fabric Scenario - Resource Group" style="width:70%;">
<br></br>

### 2. What can I demo from this scenario after deployment

This capacity size should allow for most sample data scenarios in any Fabric workload (Analytics, Engineering, ML, Reporting)

## DEMO GUIDE

### Contents

#### Validate Deployed Resources

- Fabric Capacity (F8 SKU)
- Logic App - Fabric Capacity Pause - pauses capacity every 4 hours (UTC). This may not be running on creation - go into Overview of resource and select `Run` to initialize


#### Adding Your Fabric Capacity to a Workspace

- Create a Fabric Workspace

  - Navigate to https://app.powerbi.com/

<img src="https://raw.githubusercontent.com/petender/issdata/refs/heads/main/demoguide/Fabric_Dashboard.png" alt="ISS Fabric Scenario - Dashboard" style="width:70%;">
<br></br>

- Fill in the fields (Domain not needed) - ensure that under Advanced section, that created F8 Fabric Capacity is selected

<img src="https://raw.githubusercontent.com/petender/issdata/refs/heads/main/demoguide/Create_Workspace.png" alt="ISS Create Fabric Workspace" style="width:70%;">
<br></br>
#### Resizing Capacity

- If you find costs are too high or processing is running slower than expected based on Trial F64, you can always navigate back to the Azure resource and resize at any SKU at any time.




