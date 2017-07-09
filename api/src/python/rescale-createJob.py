import requests
import sys
import os
import json


########################################################
# Open/Read cluster Json
########################################################
def read_json(json_filename):
    f = open(json_filename, 'r')
    my_json = f.read()
    f.close()
    return my_json


########################################################
# Create Job by using Rescale API
########################################################
def create_job(my_json, token):
    tokenValue = 'Token' + ' ' + token
    my_dict = json.loads(my_json)
    r = requests.post(
        'https://platform.rescale.jp/api/v3/jobs/',
        headers = {'Authorization': tokenValue},
        json = my_dict
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
return_json = read_json(args[1])

# create Job
r = create_job(return_json, token)
print(r.text)
