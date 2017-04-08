#!/usr/bin/gawk -f
#
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
#
# Copyright (c) 2017, Kristoffer Winther Balling & Laura Winther Balling
#
#
# In some configurations Tobii exports data in a wide format in which each
# area of interest (AOIs) is represented by a column and a value of 1 indicates
# a hit. All columns containing 0 or -1 are irrelevant. By including only
# hits (1) and rendering data in a long format by ID and AOI (column name), the
# resulting data is much smaller and more well adapted for further analysis.
#
# The script parses a Tobii eyetracker .tsv output file to produce:
#   1. an AOIFILE with all AOI hits indexed by an ID (long format)
#   2. an IDFILE with participant and event information indexed by ID
# 
# The data in AOIFILE and IDFILE can be joined using the ID column.
#
# By default the script removes the leading "AOI[" and trailing ""]Hit"" from
# AOIs. This trimming can be disabled by specifying: -v NOTRIM=1
#
# Column headers can be disabled by specifying: -V NOHEADERS=1  
#
# Default filenames are aois.tsv and ids.tsv for AOIs and IDs, respectively.
# Custom filenames can be specified using -v AOIFILE=custom-aoi.tsv and 
# -v IDFILE=custom-ids.tsv
#
# Usage:
#   gawk -f tobii-aoi-wide-to-long.awk \
#     -v AOIFILE=aois.tsv IDFILE=ids.tsv exported-tobii-data.tsv
#
BEGIN {
  FS = "\t"
  OFS = "\t"
  id_counter = 1
  id_columns = 13
  if (length(AOIFILE) == 0) {
    AOIFILE = "aois.tsv"
  }
  if (length(IDFILE) == 0) {
    IDFILE = "ids.tsv"
  }
}
{
  # Headers are in first record
  if (NR == 1) {
    for (i=id_columns+1;i<=NF;i++) {
      if (length(NOTRIM) == 0) {
        s=$i
        gsub(/^AOI\[/, "", s)
        gsub(/\]Hit$/, "", s)
        headers[i] = s
      } else {
        headers[i] = $i
      }
    }
    # NOHEADERS not specified
    if (length(NOHEADERS) == 0) {
      printf "id" > IDFILE
      for (i=1;i<=id_columns;i++) {
        printf "\t"$i >> IDFILE
      }
      print "" >> IDFILE
      print "id", "aoi" > AOIFILE
    }
  }
  if (NR > 1) {
    id = ""
    for (i=1;i<=id_columns;i++) {
      id=id FS $i
    }
    if (id in ids) {
      id_id=ids[id]
    } else {
      ids[id]=id_counter
      id_id=id_counter
      id_counter++
    }
    for (i=id_columns+1;i<=NF;i++) {
        if ($i == "1") {
           print id_id,  "\"" headers[i] "\"" >> AOIFILE
        }
    }
  } 
}
END {
  PROCINFO["sorted_in"] = "@val_num_asc";
  for (i in ids) {
    id_id = ids[i]
    print id_id i >> IDFILE
  }
}
