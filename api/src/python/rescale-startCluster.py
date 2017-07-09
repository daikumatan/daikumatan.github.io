import requests
import sys
import os
import json

#########################################
# Create Job by using Rescale API
#########################################
def start_persistent_cluster(cluster_id, token):
    tokenValue = 'Token' + ' ' + token
    r = requests.post(
        'https://platform.rescale.jp/api/v3/clusters/' + cluster_id + '/start/',
        headers = {'Authorization': tokenValue},
    )
    return r

############################
# main
############################

# Setting Token
for key, val in os.environ.items():
    if key == 'RESCALE_API_TOKEN':
        token = val

# read cluster json
args = sys.argv
cluster_id = args[1]

# create Job
r = start_persistent_cluster(cluster_id, token)
print(r.text)
