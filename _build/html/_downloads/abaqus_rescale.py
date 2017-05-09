# -*- coding: utf-8 -*-
import os
import sys

################################################################
# download_files: files you want to download
# rescalecli: the path you stored rescale.jar
# runscript_name: this script is sent to rescale by rescale.jar
#                 and executed by rescale platform.
################################################################
download_files = "*.log"
rescalecli = "C:/rescale/rescale.jar"
runscript_name = "submit.sh"

################################################################



def create_run_script(abaqus_info, args, script_name):

    cpus = abaqus_info['cpus']
    job = abaqus_info['job']
    scratch = abaqus_info['scratch']

    cmd = "abaqus " + " ".join(args[1:])

    s = """#!/bin/sh -f
    #RESCALE_NAME=Abaqus_from_isight_%(job)s
    #RESCALE_CORES=%(cpus)s
    #RESCALE_CORE_TYPE=hpc-3
    #RESCALE_LOW_PRIORITY=true
    #RESCALE_ANALYSIS=abaqus
    #RESCALE_ANALYSIS_VERSION=2016.extended-pcmpi
    #USE_RESCALE_LICENSE
    %(cmd)s\n
    """ % locals()

    f = open(script_name, 'w') # 書き込みモードで開く
    f.write(s.replace("    ", "")) #
    f.close() # ファイルを閉じる

def extract_abaqus_info(args):
    scratch = "${PWD}/tmp"

    for arg in args[1:]:
        if arg.startswith('cpus='):
            s = arg.split('=')
            np = s[1]
        elif arg.startswith('job='):
            s = arg.split('=')
            job = s[1]
        elif arg.startswith('scratch='):
            s = arg.split('=')
            scratch = s[1]

    flags = {}
    flags = {
                "cpus" : np,
                "job" : job,
                "scratch" : scratch
            }

    return flags

def execute_rescalecli(rescalecli, token, runscript, download_files):
    cmd = """
    java -jar %(rescalecli)s \
    -X https://platform.rescale.jp/ submit \
    -p %(token)s -E -i %(runscript)s -f %(download_files)s
    """ % locals()
    print(cmd)
    chk = os.system( cmd )

    return chk



# setup your token from os-enviroment-variable
for key, val in os.environ.items():
    if key == 'RESCALE_API_TOKEN':
        token = val

print(token)

# get arg-values & extract num_procs, jobname, scratch path
args = sys.argv
abq_info = extract_abaqus_info(args)
create_run_script(abq_info, args, runscript_name)
execute_rescalecli(rescalecli, token, runscript_name, download_files)
