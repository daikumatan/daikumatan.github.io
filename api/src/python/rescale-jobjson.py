__doc__ = """{f}

Usage:
    {f} [--file-id <file_id>] [--name <jobname>] --json <rescale_job_json>
    {f} -h | --help

Options:
    --name <jobname>
    --file-id=file_id1,file_id2...    fileIds of uploaded files
    --json <rescale_job_json> job_json file
    -h --help                 Show this screen and exit.
""".format(f=__file__)

from docopt import docopt
import requests
import sys
import os
import json

class RescaleJobJson:

    # Open/Read cluster Json
    def read(self, json_filename):
        f = open(json_filename, 'r')
        my_json = f.read()
        f.close()
        return my_json

    # add rescale fileIds to the job-json read from file
    def add_file(self, my_json, file_id):
        num_ids = len(file_id)
        my_dict = json.loads(my_json)
        if num_ids > 0:
            my_dict['jobanalyses'][0]['inputFiles'] = [0] * num_ids
            for i in range(0, num_ids):
                my_dict['jobanalyses'][0]['inputFiles'][i] = {'id': file_id[i]}
        new_json = json.dumps(my_dict)
        return new_json

    # add rescale fileIds to the job-json read from file
    def name(self, my_json, jobname):
        my_dict = json.loads(my_json)
        my_dict['name'] = jobname
        new_json = json.dumps(my_dict)
        return new_json

    # add rescale fileIds to the job-json read from file
    def core(self, my_json, code):
        my_dict = json.loads(my_json)
        my_dict['name'] = code
        new_json = json.dumps(my_dict)
        return new_json

    # add rescale fileIds to the job-json read from file
    def core_type(self, my_json, code):
        my_dict = json.loads(my_json)
        my_dict['name'] = code
        new_json = json.dumps(my_dict)
        return new_json

##############################################################
# main
##############################################################
def create_jobjson():
    args = docopt(__doc__)

    json_filename = args['--json']

    job = RescaleJobJson()
    json = job.read(json_filename)

    if args['--file-id']:
        file_ids = []
        file_ids = args['--file-id'].split(",")
        json = job.add_file(json, file_ids)

    if args['--name']:
        name = args['--name']
        json = job.name(json, name)

    return json


if __name__ == '__main__':
    result = create_jobjson()
    print(result)
