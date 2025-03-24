# Load libraries
library(remotes)
library(reticulate)
use_python("/usr/local/bin/python3.9")

start_date = '01-01-2023'
reaches = list(110151544)
source_python('src/geoglows_aws_pull.py')
tributary_flow = pull_tributary(reach_id = reaches, start_date=start_date)
print(tributary_flow)