Convert Tobii AOI data (wide to long format)
============================================

In some configurations Tobii exports data in a wide format in which each
area of interest (AOIs) is represented by a column and a value of 1 indicates
a hit. All columns containing 0 or -1 are irrelevant. By including only
hits (1) and rendering data in a long format by ID and AOI (column name), the
resulting data is much smaller and more well adapted for further analysis.

The script parses a Tobii eyetracker .tsv output file to produce:
  
  1. an AOIFILE with all AOI hits indexed by an ID (long format)
  2. an IDFILE with participant and event information indexed by ID
 
The data in ```AOIFILE``` and ```IDFILE``` can be joined using the ID column.

By default the script removes the leading "AOI[" and trailing ""]Hit"" from
AOIs. This trimming can be disabled by specifying: ```-v NOTRIM=1```

Column headers can be disabled by specifying: ```-v NOHEADERS=1```  

Default filenames are aois.tsv and ids.tsv for AOIs and IDs, respectively.
Custom filenames can be specified using ```-v AOIFILE=custom-aoi.tsv``` and 
```-v IDFILE=custom-ids.tsv```

Usage:
-------

```gawk -f tobii-aoi-wide-to-long.awk exported-tobii-data.tsv```

License
-------

[Mozilla Public License Version 2.0](http://mozilla.org/MPL/2.0/)

Author Information
------------------

Kristoffer Winther Balling (kwballing@gmail.com) & Laura Winther Balling (laura.balling@gmail.com)