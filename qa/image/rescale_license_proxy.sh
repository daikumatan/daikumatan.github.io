#!/bin/sh
ssh rescale@rescale.tunnel.rescale.com -R 41401:lic-rescalejapan:41401 -R 1055:lic-rescalejapan:1055 -R 2325:lic-rescalejapan:2325 -R 33623:lic-rescalejapan:33623 -R 27000:lic-rescalejapan:27000 -R 30000:dell-pc:30000 -R 52734:lic-rescalejapan:52734 -v -N
