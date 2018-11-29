# sweep parameters of component - synthesise in Quartus and collect timing results
import re
import os
import math

log_file = 'syn.log'
proj = 'add_sub_top'

stat_list = []

print 'Circuit Statistics'
print '--------------------------------------------------------------------------------'
print 'width\t\tblock\t\taluts\t\tslack\t\ttprop'
print '--------------------------------------------------------------------------------'

# for n in [4]:
for n in range(4,68,4):
    grp_size = int(math.sqrt(n))
    while n % grp_size != 0:
      grp_size = grp_size + 1

    os.system('rm -rf %s %s %s' % (log_file, '*db', '*_output')) 

    quartus_job = '''
    quartus_sh --script=add_sub_top.tcl add_sub_top > syn.log;
    quartus_map --verilog_macro="WIDTH=%d" --verilog_macro="ARCH=%d" --verilog_macro="GRP_WIDTH=%d" add_sub_top >> syn.log;
    quartus_fit add_sub_top >> syn.log;
    quartus_sh -t add_sub_fitter.tcl >> syn.log;
    # quartus_asm add_sub_top >> syn.log;
    quartus_sta -t add_sub_sta.tcl >> syn.log;
    ''' % (n, 1, grp_size)

    os.system(quartus_job)

    try:
        f = open(log_file)
    except:
        print('Error: Cannot open file: %s' % log_file, 1)
        exit()

    log_lines = f.readlines()

    for line in log_lines:
        match = re.search(r'Setup slack is\s*(\d+\.\d*)', line)   
        if match:
            slack = float(match.group(1))

        match = re.search(r'aluts (\d*,?\d+)', line)
        if match:
            aluts = match.group(1)
            aluts = int(re.sub(r',','',aluts))

    tprop = 10.0 - slack

    print n,'\t\t',grp_size,'\t\t',aluts,'\t\t',slack,'\t\t',tprop
    
    stat_list.append({'width': n, 'slack':slack, 'aluts':aluts, 'tprop': tprop})
    f.close()

try:
    f = open('syn_timing.dat', 'wb')
except:
    print('Error: Cannot open synthesis data file for writing')
    exit()

for stats in stat_list:
    line = '%d %f \n' % (stats['width'], stats['tprop'])
    f.write(line)    

f.close()

try:
    f = open('syn_area.dat', 'wb')
except:
    print('Error: Cannot open synthesis data file for writing')
    exit()

for stats in stat_list:
    line = '%d %d \n' % (stats['width'], stats['aluts'])
    f.write(line)    

f.close()




