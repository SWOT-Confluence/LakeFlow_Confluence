# LakeFLow code for Confluence purposes


# Test LakeFlow code on 5 lake ids

- lakeid1.csv: 
    - This csv includes 5 lake ids to test LakeFlow. 

- lakeflow_input.R
    - This script downloads and saves swot and ancillary data by lake in the folder "in/clean". It also saves a list of lakes where lakeflow is viable to run in the folder "in/viable". 
    - It takes two arguments. The first is a filepath to the a list of lake ids. The second is the number of cores to use when downloading swot data. 
    - I set up this script so that i could easily use it with job array. Since the script will be run many times and save many lists of viable lakes, i've been setting it up to take a .csv of lake ids named "lakeid[1-n].csv" and then use the [1-n] to save the list of viable lakes so nothing is overwritten. For example, if the input lake list is named "lakeid5.csv" then the output list of viable lakes will be named "viable_locations5.csv". 

- lakeflow_deploy.R: 
    - This script runs lakeflow at the viable locations. 
    - It takes two arguments. The filepath to the list of viable locations and the number of cores to use for the lakeflow optimization. 
    - This saves lakeflow outputs like normal - nothing to worry about with job array stuff. 
    
- Run lakeflow_1.R and then lakeflow_2.R. 

- Use the lakeid1.csv as the first argument to the script lakeflow_1.R. Use the output from lakeflow_1.R in "in/viable/viable_locations1.csv" as the first argument to the script lakeflow_2.R. 


### Travis lakeflow input update:

- Created README
- reanamed lakeflow_1 to lakflow_input and lakeflow_2 to lakeflow_deploy
- moved dockerfiles to top of the repo
- created two dockerfiles one for input and one for deployment with entrypoints
- added new indir argument
- replaced all 'in' filepaths with indir argument
- Updated dockerfile to copy in scripts for entrypoint
- updated argument handling by using optparse
- added optparse to requirement.R

### Travis lakeflow deploy update:
- Updated dockerfile to be in line with lakeflow input
- updated argument handling to opptparse
- added new argument to point to the directory holding the sos

### To do for AWS Deployment
- aded index argument 
- added a IAM policy to ecstaskececutionrole:

{
  "Effect": "Allow",
  "Action": ["s3:GetObject", "s3:ListBucket"],
  "Resource": [
    "arn:aws:s3:::geoglows-v2-retrospective",
    "arn:aws:s3:::geoglows-v2-retrospective/*"
  ]
}

- update output netcdf
- make lake sets / in 'lakeflow input' module after Ryan sends upstreea/downstream code
- find what data lakeflow is using that is already available in confluencce
    - dx area
- add a flag that saves or doesn't save intermediate data
- setup EFS for Lakeflow
- Setup bath compute environment for lakeflow