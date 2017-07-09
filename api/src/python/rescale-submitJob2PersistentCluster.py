import requests
import sys
import os
import json

########################################################
# Create Job by using Rescale API
########################################################
def submit_job_to_persistent_cluster(job_id, cluster_id, token):
    tokenValue = 'Token' + ' ' + token

    r = requests.post(
        'https://platform.rescale.jp/api/v3/clusters/' + cluster_id + '/jobs/',
        headers = {'Authorization': tokenValue},
        json = {'id': job_id, 'submit': True}
    )
    return r


########################################################
# main
########################################################

# Setting Token
for key, val in os.environ.items():
    if key == 'RESCALE_API_TOKEN':
        token = val

# read cluster json
args = sys.argv
job_id = args[1]
cluster_id = args[2]

# create Job
r = submit_job_to_persistent_cluster(job_id, cluster_id, token)
print(r.text)
