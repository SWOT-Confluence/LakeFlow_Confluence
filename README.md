<hr>

<div align="left">

<h1 align="left">LakeFlow (Confluence Version)</h1>

</div>

LakeFlow is an algorithm that is used to estimate the discharge of river reaches flowing into or out of lakes. It relies on a lake mass balance framework that incorporates SWOT measurements of river-lake systems. This version of LakeFlow is specifically designed to run globally as a supplementary module within SWOT's Confluence discharge computation platform. 

The LakeFlow algorithm is split into two parts, which must be run in serial. The first part, `LakeFlow input`, identifies global lakes where LakeFlow can successfully run, based on our requirements. The second part, `LakeFlow deploy`, runs LakeFlow's mass balance algorithm at the viable lake locations.

In addition to SWOT River & LakeSP data, which are pulled within the algorithm using the Hydrocron API, LakeFlow also requires tributary discharge estimates from the GeoGlows hydrologic model, priors from the SWOT Sword of Science (SoS), evaporation estimates from the Daily Lake Evaporation Model, and other geospatial linkage files. The GeoGlows data are stored on AWS and accessed through the LakeFlow scripts. The SoS priors and SWORD network files are already stored in the Confluence mnt in NC format. The evaporation estimates and geospatial linkage files (listed below) are provided in CSV format and are now also stored in the Confluence mnt.

* `mnt/input/lakeflow/SWORDv17b_PLDv201.csv`
* `mnt/input/lakeflow/ancillary/et.csv`
* `mnt/input/lakeflow/ancillary/et_supplement.csv`
* `mnt/input/lakeflow/ancillary/sword_geoglows.csv`
* `mnt/input/lakeflow/ancillary/tributaries.csv`

## LakeFlow scripts and other files
`src/lakeflow_1.R`
* This script saves a list of lake_ids in `viable_locations.csv`, which is stored in the `mnt/input/lakeflow/viable` directory.
* Additionally, the script saves SWOT and ancillary data by lake. These CSVs are stored as intermediate outputs in the `mnt/input/lakeflow/clean` directory.

`src/lakeflow_2.R`
* This script produces a CSV file per lake saved within the `mnt/flpe/lakeflow` folder containing all the output values for LakeFlow.
* During Confluence's output module, these intermediate CSV files are written to the final NC within a separate LakeFlow group. 

`src/geoglows_aws_pull.py`
* This Python code is used to retrieve discharge estimates from the GeoGlows model. It is called in the `lakeflow_1.R` script.

`src/lakeflow_stan_flexible.stan`
* This Stan code is used to apply the Bayesian inference that constrains the uncertainty in unknown parameters for LakeFlow. It is called in the `lakeflow_2.R` script.

`Dockerfile_input`
* Dockerfile for `lakeflow_1.R`

`Dockerfile_deploy`
* Dockerfile for `lakeflow_2.R`

## Command line arguments
### LakeFlow input
* -c: Path to input file specifying the lakes to try processing with LakeFlow. For Confluence purposes this can be the reaches_of_interest.json (lakes associated with those reaches will be processed), but it can also be a CSV with lake ids (e.g., from the Harmonized SWORD-PLD).
* -w: Number of workers to use to download SWOT data, typically 1.
* -i: Directory with input files (e.g., `/mnt/input/lakeflow`).
* -s: Path to the SWORD network files.
* -v: Version of SWORD we are using.
* -p: Prefix for Hydrocron API-key storage (optional).

### LakeFlow deploy
* -c: File path for a list of lakes to run LakeFlow. For Confluence purposes, this is typically the path to `viable_locations.csv`.
* -s: File path to the SoS.
* -w: Number of cores for LakeFlow to use, typically 1.
* -i: Directory with input files (e.g., `/mnt/input/lakeflow`).
* -o: Directory to output results (e.g., `/mnt/flpe/lakeflow`).
* -v: Version of SWORD we are using.
* Index of what lake to process in the input file. If blank, process the whole file.

## Publications on LakeFlow

* [Riggs et al. (2023). Turning Lakes Into River Gauges Using the LakeFlow Algorithm](https://doi.org/10.1029/2023GL103924)
* [Riggs et al. (2026). Characterizing operational signatures of reservoirs with the SWOT satellite by comparing natural lake and reservoir dynamics](https://doi.org/10.1088/1748-9326/ae436e)

## Code for other versions of LakeFlow
1. Global application of LakeFlow: [https://github.com/hanathurman/Global-River-Lake-Hydro](https://github.com/hanathurman/Global-River-Lake-Hydro)
   * The code here is very similar to this Confluence repository, but it is the version we use on our local HPC for testing, development, and science applications. There may be some differences between the two versions at any given time.
   * Will be associated with an upcoming paper on harmonizing river discharge and lake storage changes.
2. Original LakeFlow codebase: [https://github.com/Ryan-Riggs/LakeFlow](https://github.com/Ryan-Riggs/LakeFlow)
   * Code associated with the paper "Turning Lakes Into River Gauges Using the LakeFlow Algorithm" (Riggs et al., 2023)
3. Application of LakeFlow across North America: [https://doi.org/10.5066/P14FJTZH](https://doi.org/10.5066/P14FJTZH)
   * Code associated with the paper "Characterizing operational signatures of reservoirs with the SWOT satellite by comparing natural lake and reservoir dynamics" (Riggs et al., 2026)