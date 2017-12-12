import datetime 
hr = 23.0
msn = 59.0
ch = int(datetime.datetime.now().strftime('%H'))
cm = int(datetime.datetime.now().strftime('%M'))
cs = int(datetime.datetime.now().strftime('%S'))
rp = int(ch/hr * 200.0) + 55
gp = int(cm/msn * 200.0) + 55
bp = int(cs/msn * 200.0) + 55
print('{:X}{:X}{:X}'.format(rp,gp,bp))

