# snAneu
Single cell analysis of aneuploidy

Eran Mukamel (emukamel@ucsd.edu)

This analysis pipeline uses the Ginkgo software (https://github.com/robertaboukhalil/ginkgo).

To run the pipeline:
1. Install ginkgo into the directory ./ginkgo
2. Install this repository (git clone)
3. Move the script: <p><code>mv process_from_gzipped_data.R ginkgo/scripts/</code></p>
4. Create a cell-by-bin table of coverage:
<ul>
  <li>Convert allc files to binc files. Alternatively: <p> <code>01.allc2binc.sh BINSIZE ALLC_FILENAME</code></p></li>
  <li> Merge binc files into a table containing all cells for one sample. NOTE: Need to set the path to the : <p><code>python 01.binc.py</p></code></li>
    <li><code>01.binc2data.ipynb</code></li>
</ul>  
5. Run ginkgo: <code>02.ginkgo.sh SAMPLE_DIR</code>
6. Find "bad bins" with poor mappability and inconsistent coverage: <code>03.badbins.ipynb</code>
7. <code>04.run_CNV_caller.sh SAMPLE_DIR</code>
8. <code>05.calculate_MAD.ipynb</code>
9. Example notebook for downstream analysis: <code>Ginkgo_CEMBA_March2022.ipynb</code>
    
