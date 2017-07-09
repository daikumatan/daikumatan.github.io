import requests
import sys
import os
import json

#########################################
# Open/Read cluster Json
#########################################
def read_my_json(myjson):
    f = open(myjson, 'r')
    mycluster_json = f.read()
    mycluster_dict = json.loads(mycluster_json)
    f.close()
    return mycluster_dict


#########################################
# Create Job by using Rescale API
#########################################
def create_persistent_cluster(myjson, token):
    tokenValue = 'Token' + ' ' + token

    r = requests.post(
        'https://platform.rescale.jp/api/v3/clusters/',
        headers = {'Authorization': tokenValue},
        json = myjson
    )
    return r


#########################################
# write json file to current directory
#########################################
def write_data(data, filename):
    f = open(filename, 'w')
    f.write(r.text)
    f.close()
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
mycluster_dict = read_my_json(args[1])

# create Job
r = create_persistent_cluster(mycluster_dict, token)
print(r.text)
