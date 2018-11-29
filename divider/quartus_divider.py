# sweep parameters of component - synthesise in Quartus and collect timing results
import re
import os

log_file = 'syn.log'
proj = 'divider_top'

stat_list = []

print 'Circuit Statistics'
print '--------------------------------------------------------------------------------'
print 'width\t\taluts\t\tregs\t\tslack\t\ttprop'
print '--------------------------------------------------------------------------------'

#for n in [4]:    
for n in range(4,36,4):
    os.system('rm -rf %s %s %s' % (log_file, '*db', '*_output')) 

    quartus_job = '''
    quartus_sh --script=divider_top.tcl divider_top > syn.log;
    quartus_map --verilog_macro="WIDTH=%d" --verilog_macro="ARCH=%d" --verilog_macro="GRP_WIDTH=%d" --verilog_macro="PIPE=1" divider_top >> syn.log;    
    quartus_fit divider_top >> syn.log;
    quartus_sh -t divider_top_fitter.tcl >> syn.log;
    # quartus_asm divider_top >> syn.log;
    quartus_sta -t divider_top_sta.tcl >> syn.log;
    ''' % (n, 0, 4)

    os.system(quartus_job)

    try:
        f = open(log_file)
    except:
        print('Error: Cannot open file: %s' % log_file)
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

        match = re.search(r'regs (\d*,?\d+)', line)
        if match:
            regs = match.group(1)
            regs = int(re.sub(r',','',regs))

    # tprop = 100.0 - slack      # combinatorial constraint is 100ns
    tprop = 10.0 - slack        # pipelined constraint is 10ns

    print n,'\t\t',aluts,'\t\t',regs,'\t\t',slack,'\t\t',tprop
    
    stat_list.append({'width': n, 'slack':slack, 'aluts':aluts, 'regs':regs, 'tprop': tprop})
    f.close()

try:
    f = open('div_syn_timing.dat', 'wb')
except:
    print('Error: Cannot open synthesis data file for writing')
    exit()

for stats in stat_list:
    line = '%d %f' % (stats['width'], stats['tprop'])
    f.write(line)    

f.close()

try:
    f = open('div_syn_area.dat', 'wb')
except:
    print('Error: Cannot open synthesis data file for writing')
    exit()

for stats in stat_list:
    line = '%d %d \n' % (stats['width'], stats['aluts'])
    f.write(line)    

f.close()




