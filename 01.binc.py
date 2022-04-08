import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import glob,re,time,os
from multiprocessing import Pool

######### PARAMETERS
# Each sample should have its own directory with files named binc_{sample}_{binsize}.tsv.gz
binsize=1e5
basedir='/PATH/TO/OUTPUT/FILES'
datadirs = glob.glob('/PATH/TO/BINC/FILES')
#########

    
def merge_binc(sample,binsize=binsize):
    # Create 100kb binc tables for each sample
    # 1 row for each bin, 1 column per cell
    t0=time.time()
    outfile=basedir+'%s/binc_%s_%d.tsv.gz' % (sample,sample,binsize)
    if os.path.isfile(outfile):
        print('File exists, skipping %s' % outfile)
        return
    else:
        print('Processing %s' % sample)
        os.system('mkdir -p %s/%s' % (basedir,sample))
        os.system('touch %s' % outfile)
    
    files=glob.glob('%s/../Datasets/%s/binc/binc_*_10000.tsv.bgz' % (basedir,sample))
    if len(files)==0:
        print('No files! Skipping %s' % sample)
        return
    dfs = []
    for file in files:
        df = pd.read_csv(file,sep='\t',
                        compression='gzip',dtype={'chr':str})
        df['bin_end'] = np.floor(df['bin']/binsize)*binsize
        df = df.groupby(['chr','bin_end'])[['mCH','CH','mCG','CG','mCA','CA']].sum()
        cell=file.split('/')[-1].replace('_10000.tsv.bgz','').replace('binc_','')
        df=df.rename(columns=lambda x: '%s_%s' % (x,cell))
        dfs.append(df)
    df = dfs[0].join(dfs[1:])
    df.to_csv(outfile, sep='\t')
    
    # Now write out a data file with just the coverage
    outfile2=basedir+'/%s/%s.tsv.gz' % (sample,sample)
    ch = data.filter(regex=r'^CH_')
    ch.columns = ch.columns.str.replace(r'^CH_','')
    ch = data[['chr','bin_end']].join(ch)
    ch['bin_end'] = ch['bin_end'].astype(int)
    ch.to_csv(outfile2,sep='\t',index=False)
    
    print('Finished %s; t=%3.3f s' % (sample,time.time()-t0))

datasets = [i.split('/')[-1] for i in datadirs]
with Pool() as pool:
    pool.map(merge_binc,datasets)
